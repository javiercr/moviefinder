class CreateGenres < ActiveRecord::Migration
  def change
     create_table :genres do |t|
       t.string   :name
     end
     create_table :genres_movies do |t|
       t.integer   :genre_id
       t.integer   :movie_id
     end
   end
end
