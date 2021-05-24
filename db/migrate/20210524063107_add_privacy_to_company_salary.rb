class AddPrivacyToCompanySalary < ActiveRecord::Migration[6.1]
  def change
    add_column :company_salaries, :privacy, :boolean, default: false
  end
end
