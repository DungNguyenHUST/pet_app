class CreateScrapCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :scrap_companies do |t|
      t.integer "page_num"
      t.string "url"

      t.timestamps
    end
  end
end
