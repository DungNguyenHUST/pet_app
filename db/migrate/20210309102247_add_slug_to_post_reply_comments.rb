class AddSlugToPostReplyComments < ActiveRecord::Migration[6.0]
  def change
    add_column :post_reply_comments, :slug, :string
    add_index :post_reply_comments, :slug, unique: true
  end
end
