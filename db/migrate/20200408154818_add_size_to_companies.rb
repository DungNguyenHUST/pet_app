class AddSizeToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :size, :integer
  end
end
