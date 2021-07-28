class CreateScrapJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :scrap_jobs do |t|
      t.integer   :company_id
      t.string    :company_name
      t.string    :url
      
      t.timestamps
    end
  end
end
