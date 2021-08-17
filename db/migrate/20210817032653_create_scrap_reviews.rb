class CreateScrapReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :scrap_reviews do |t|
      t.integer "company_id"
      t.string "company_name"
      t.string "url"
      t.text "raw_data"
      t.timestamps
    end
  end
end
