class AddWallPictureToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :wall_picture, :string
  end
end
