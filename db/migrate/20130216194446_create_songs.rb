class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :artist
      t.string :title
      t.string :duration
      t.string :url
      t.integer :list_id

      t.timestamps
    end
  end
end
