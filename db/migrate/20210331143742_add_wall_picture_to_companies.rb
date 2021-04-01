class AddWallPictureToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :wall_picture, :string
  end
end
