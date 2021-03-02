class AddPhoneToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :phone, :string
  end
end
