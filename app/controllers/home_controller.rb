class HomeController < ApplicationController

  def index
    @movies = Movie.all(:order => "imdb_rating desc")
  end


end
