class AddPolicyToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :policy, :text
  end
end
