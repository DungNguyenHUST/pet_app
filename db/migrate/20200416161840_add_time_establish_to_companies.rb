class AddTimeEstablishToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :time_establish, :datetime
  end
end
