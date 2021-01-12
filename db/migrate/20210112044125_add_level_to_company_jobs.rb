class AddLevelToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :level, :string
  end
end
