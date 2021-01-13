class AddUserIdToCompanySaveJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_save_jobs, :user_id, :integer
  end
end
