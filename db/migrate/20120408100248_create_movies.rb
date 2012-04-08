class CreateMovies < ActiveRecord::Migration
  def change
     create_table :movies do |t|
       t.string   :title
       t.integer  :imdb_id
       t.decimal  :imdb_rating
       t.string   :imdb_link
       t.integer  :imdb_year
       t.string   :poster
     end
   end
end
