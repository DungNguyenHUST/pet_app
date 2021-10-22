class AddDefaultToScrap < ActiveRecord::Migration[6.1]
  def change
    add_column :scrap_jobs, :approved, :boolean, default: false
    add_column :scrap_reviews, :approved, :boolean, default: false
  end
end
