class CreatePostReplyComments < ActiveRecord::Migration[6.0]
  def change
    create_table :post_reply_comments do |t|
      t.string :user_name
      t.text :reply_content
      t.integer :post_comment_id

      t.timestamps
    end
  end
end
