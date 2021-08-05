class AddEmployerToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :employer_id, :integer
  end
end
