class AddJobIdToCompanySaveJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_save_jobs, :company_job_id, :integer
  end
end
