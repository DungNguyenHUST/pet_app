class AddSlugToCompanyReplyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reply_reviews, :slug, :string
    add_index :company_reply_reviews, :slug, unique: true
  end
end
