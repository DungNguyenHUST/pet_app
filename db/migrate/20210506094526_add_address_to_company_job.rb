class AddAddressToCompanyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :address, :string
  end
end
