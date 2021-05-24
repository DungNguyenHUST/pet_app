class AddLevelToCompanySalary < ActiveRecord::Migration[6.1]
  def change
    add_column :company_salaries, :level, :integer
  end
end
