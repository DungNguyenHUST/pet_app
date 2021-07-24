class AddDetailToCompanyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :detail, :string
  end
end
