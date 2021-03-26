class AddSlugToPostComments < ActiveRecord::Migration[6.0]
  def change
    add_column :post_comments, :slug, :string
    add_index :post_comments, :slug, unique: true
  end
end
