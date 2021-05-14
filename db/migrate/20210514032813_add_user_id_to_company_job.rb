class AddUserIdToCompanyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :user_id, :integer
  end
end
