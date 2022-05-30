class AddVisitorIdToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :user_id, :integer
    add_column :companies, :visitor_id, :string

    add_index :companies, [:created_at, :user_id, :visitor_id]
  end
end
