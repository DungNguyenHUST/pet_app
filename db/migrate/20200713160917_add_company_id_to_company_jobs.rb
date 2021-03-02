class AddCompanyIdToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :company_id, :integer
  end
end
