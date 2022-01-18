class AddProcessToCompanyApplyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_apply_jobs, :process, :integer, default: -1
  end
end
