require  "#{Rails.root.to_s}/config/environment"
require 'open-uri'
require 'zlib'

namespace :moviefinder  do

  task :find_movies do
    @ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_6) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.9 Safari/536.5"
    @movies = Array.new
    keep_going = true
    page = 1
    while keep_going do
      # Open KAT RSS ordered by seeds
      puts "Fetching http://kat.ph/movies/?field=seeders&sorder=desc&page=#{page}&rss=1"
      rss = Nokogiri::XML(open("http://kat.ph/movies/?field=seeders&sorder=desc&page=#{page}&rss=1", "User-Agent" => @ua))

      # For each RSS item
      rss.xpath("//item").each do |rss_node|
        begin
          torrent = Torrent.new

          torrent.file = rss_node.xpath('torrentLink').inner_text
          # Check if we got this torrent already (sometimes they're repeated in the RSS)
          next unless Torrent.find_by_file(torrent.file).nil?
          
          torrent.name = rss_node.xpath('title').inner_text
          next if torrent.poor_quality?
          
          # Find its quality
          torrent.find_quality
          
          torrent.seeds = rss_node.xpath('seeds').inner_text.to_i
          if torrent.low_seeds?
            keep_going = false 
            # We break here because the RSS is order by seeds, so it means we've reached the minimum seed number
            break
          end
          next if torrent.low_ratio?
          
          torrent.leechs = rss_node.xpath('leechs').inner_text.to_i
          torrent.link = rss_node.xpath('link').inner_text

  
          # Open KAT torrent page
          puts "Fetching #{torrent.link}"
          page_kat_stream = open(torrent.link, "User-Agent" => @ua)
          # Sometimes we got gziped content
          if (page_kat_stream.content_encoding.empty?)
            page_kat = Nokogiri::HTML(page_kat_stream.read)
          else
            page_kat = Nokogiri::HTML(Zlib::GzipReader.new(page_kat_stream).read)
          end
          
          # IMDB ID
          imdb_id_node = page_kat.at_xpath("//strong[text()='IMDB link:']/following-sibling::*")
          next if imdb_id_node.nil?
          imdb_id = imdb_id_node.inner_text
          
          
          # Check if we already have that movie in the DB
          movie = Movie.find_by_imdb_id(imdb_id)

          if movie.nil?
            # Create and fetch data from IMDB
            movie = Movie.new
            movie.imdb_id = imdb_id
            movie.imdb_link = "http://imdb.com/title/tt#{movie.imdb_id}"
    
            # Open IMDB movie page
            puts "Fetching #{movie.imdb_link}"
            page_imdb =  Nokogiri::HTML(open(movie.imdb_link, "Accept-Language" => "en-US,en;q=0.8", "User-Agent" => @ua))
          
            # Rating
            imdb_rating_node = page_imdb.at_css('.star-box-giga-star')
            next if imdb_rating_node.nil?
            movie.imdb_rating = imdb_rating_node.inner_text.to_f
            next if movie.too_bad?

            # Year
            imdb_year_node = page_imdb.at_css('h1.header span.nobr')
            movie.imdb_year = imdb_year_node.inner_text.gsub(/[()]/,"").to_i
            imdb_year_node.unlink # Remove so it doesn't appear in the title
          
            # Title
            movie.title = page_imdb.at_css('h1.header').inner_text
            
            # Poster
            img_node = page_imdb.at_css('img[itemprop="image"]')
            next if img_node.nil?
            poster_url = img_node.attribute('src').to_s
            movie.fetch_poster(poster_url, @ua)
            
            @movies << movie
          end
  
          # Save Torrent
          movie.torrents << torrent
          movie.save

          puts "Movies count #{@movies.count}"
          # Exit?
          if @movies.count == 48
            keep_going = false 
            break
          end

        # If we're flooding...
        rescue
          sleep 5
          puts $!, $@
          puts 'Retry...'
          retry
        end
      end
      page += 1
  
    end
  end
end