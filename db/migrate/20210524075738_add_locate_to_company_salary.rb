class AddLocateToCompanySalary < ActiveRecord::Migration[6.1]
  def change
    add_column :company_salaries, :locate, :integer
  end
end
