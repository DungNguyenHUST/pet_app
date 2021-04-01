class AddWallPictureToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :wall_picture, :string
  end
end
