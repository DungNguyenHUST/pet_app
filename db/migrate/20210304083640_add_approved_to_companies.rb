class AddApprovedToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :approved, :boolean, default: false
  end
end
