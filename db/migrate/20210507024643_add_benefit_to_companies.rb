class AddBenefitToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :benefit, :text, array: true, default: []
  end
end
