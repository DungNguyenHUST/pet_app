class AddCompanyTypeToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :company_type, :string
  end
end
