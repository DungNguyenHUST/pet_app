class AddEndDateToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :end_date, :datetime
  end
end
