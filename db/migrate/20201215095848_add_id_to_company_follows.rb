class AddIdToCompanyFollows < ActiveRecord::Migration[6.0]
  def change
    add_column :company_follows, :company_id, :integer
    add_column :company_follows, :user_id, :integer
  end
end
