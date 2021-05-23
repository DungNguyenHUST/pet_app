class AddRecommendToCompanyReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :company_reviews, :recommend, :boolean
  end
end
