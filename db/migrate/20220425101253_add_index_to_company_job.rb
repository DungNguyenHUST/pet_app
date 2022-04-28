class AddIndexToCompanyJob < ActiveRecord::Migration[6.1]
  def change
    add_index :company_jobs, :company_id
    add_index :company_jobs, :employer_id
  end
end
