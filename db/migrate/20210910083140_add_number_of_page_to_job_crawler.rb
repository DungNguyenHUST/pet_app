class AddNumberOfPageToJobCrawler < ActiveRecord::Migration[6.1]
  def change
    add_column :scrap_jobs, :page_num, :integer
  end
end
