class CreatePostComments < ActiveRecord::Migration[6.0]
  def change
    create_table :post_comments do |t|
      t.string :user_name
      t.text :comment_content
      t.integer :post_id

      t.timestamps
    end
  end
end
