class AddWorkingTimeToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :working_time, :string
  end
end
