class AddUrgentTypeToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :urgent, :boolean, default: false
  end
end
