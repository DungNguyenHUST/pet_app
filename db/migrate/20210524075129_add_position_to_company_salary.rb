class AddPositionToCompanySalary < ActiveRecord::Migration[6.1]
  def change
    add_column :company_salaries, :position, :integer
  end
end
