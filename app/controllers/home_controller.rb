class HomeController < ApplicationController

  def index
    @movies = Movie.includes(:torrents).order("imdb_rating DESC").scoped
    @movies = @movies.where("genres.id IN (?)", params[:genre_ids]).joins(:genres).group("movies.id") if params[:genre_ids]
    respond_to do |format|
      format.js { render :action  => :filter_movies}
      format.html
    end
  end


end
