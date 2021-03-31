class AddAvatarToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :avatar, :string
  end
end
