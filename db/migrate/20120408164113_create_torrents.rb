class CreateTorrents < ActiveRecord::Migration
  def change
     create_table :torrents do |t|
       t.integer  :movie_id
       t.integer  :seeds
       t.integer  :leechs
       t.string   :name
       t.string   :link
       t.string   :file
       t.string   :quality
     end
   end
end
