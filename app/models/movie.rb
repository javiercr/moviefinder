class Movie < ActiveRecord::Base
  has_many :torrents
  
  def too_bad?
    self.imdb_rating < 7
  end
  
  
end