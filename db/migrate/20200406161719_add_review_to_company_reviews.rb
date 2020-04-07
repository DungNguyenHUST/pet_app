class AddReviewToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :review, :string
  end
end
