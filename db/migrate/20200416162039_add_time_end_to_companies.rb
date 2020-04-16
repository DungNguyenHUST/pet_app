class AddTimeEndToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :time_end, :datetime
  end
end
