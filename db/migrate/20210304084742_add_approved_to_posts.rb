class AddApprovedToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :approved, :boolean, default: false
  end
end
