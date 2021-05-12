class AddUserIdToPostReplyComment < ActiveRecord::Migration[6.1]
  def change
    add_column :post_reply_comments, :user_id, :integer
  end
end
