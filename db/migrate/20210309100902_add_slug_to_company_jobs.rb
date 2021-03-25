class AddSlugToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :slug, :string
    add_index :company_jobs, :slug, unique: true
  end
end
