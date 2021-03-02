class AddDateToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :date, :integer
  end
end
