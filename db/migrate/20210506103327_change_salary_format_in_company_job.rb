class ChangeSalaryFormatInCompanyJob < ActiveRecord::Migration[6.1]
  def up
    change_column :company_jobs, :salary, :string
  end

  def down
    change_column :company_jobs, :salary, :integer
  end
end
