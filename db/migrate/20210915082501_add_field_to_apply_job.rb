class AddFieldToApplyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_apply_jobs, :phone, :string
    add_column :company_apply_jobs, :address, :string
  end
end
