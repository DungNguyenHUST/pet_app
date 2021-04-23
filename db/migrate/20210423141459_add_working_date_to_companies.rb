class AddWorkingDateToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :working_date, :string
  end
end
