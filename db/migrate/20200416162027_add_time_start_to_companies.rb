class AddTimeStartToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :time_start, :datetime
  end
end
