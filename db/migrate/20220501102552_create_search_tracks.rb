class CreateSearchTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :search_tracks do |t|
      t.string :visitor_id
      t.integer :user_id
      t.string :search_type
      t.string :query
      t.integer :results_count

      t.timestamps
    end

    add_index :search_tracks, [:created_at, :user_id, :visitor_id]
  end
end