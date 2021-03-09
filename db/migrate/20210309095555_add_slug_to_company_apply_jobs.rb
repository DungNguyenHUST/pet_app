class AddSlugToCompanyApplyJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :company_apply_jobs, :slug, :string
    add_index :company_apply_jobs, :slug, unique: true
  end
end
