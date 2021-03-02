class AddJobTypeToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :job_type, :string
  end
end
