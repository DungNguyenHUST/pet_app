class AddLocationToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :location, :string
  end
end
