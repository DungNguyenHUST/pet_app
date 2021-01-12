class AddTypeToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :type, :integer
  end
end
