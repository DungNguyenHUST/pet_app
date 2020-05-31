class AddOverviewToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :overview, :text
  end
end
