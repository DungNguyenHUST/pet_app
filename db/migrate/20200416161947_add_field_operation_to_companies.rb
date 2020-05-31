class AddFieldOperationToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :field_operetion, :string
  end
end
