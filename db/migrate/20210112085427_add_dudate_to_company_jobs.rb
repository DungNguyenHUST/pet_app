class AddDudateToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :dudate, :datetime
  end
end
