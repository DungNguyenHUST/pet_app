class AddBonusToCompanySalary < ActiveRecord::Migration[6.1]
  def change
    add_column :company_salaries, :salary_bonus, :integer
  end
end
