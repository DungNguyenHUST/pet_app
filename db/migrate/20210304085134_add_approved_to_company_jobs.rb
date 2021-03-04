class AddApprovedToCompanyJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :approved, :boolean, default: false
  end
end
