class Movie < ActiveRecord::Base
  has_many :torrents
  has_and_belongs_to_many :genres
  has_attached_file :poster
    
  def too_bad?
    self.imdb_rating < 7
  end
  
  
  def fetch_poster(url, ua)
    begin
      io = open(URI.escape(url), "User-Agent" => ua)
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
        self.poster = io
      end
      self.save(false)
    rescue Exception => e
      logger.info "EXCEPTION# #{e.message}"
    end
  end
  
end