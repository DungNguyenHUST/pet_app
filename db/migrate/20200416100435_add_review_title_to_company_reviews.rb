class AddReviewTitleToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :review_title, :text
  end
end
