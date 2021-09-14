class AddEmployerIdToJob < ActiveRecord::Migration[6.1]
  def change
    rename_column :company_jobs, :user_id, :admin_id
    change_column :company_jobs, :urgent, :string
    add_column :company_jobs, :employer_id, :integer
    add_column :company_jobs, :sponsor, :string
    add_column :company_jobs, :view_count, :integer
  end
end
