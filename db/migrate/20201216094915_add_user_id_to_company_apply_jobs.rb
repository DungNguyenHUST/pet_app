class AddUserIdToCompanyApplyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_apply_jobs, :user_id, :integer
  end
end
