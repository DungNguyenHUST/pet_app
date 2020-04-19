class CreateCompanyReplyReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :company_reply_reviews do |t|
      t.string :user_name
      t.string :reply_content
      t.integer :company_review_id

      t.timestamps
    end
  end
end
