class AddValuesToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :values, :string
  end
end
