class AddAverageScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :average_score, :integer
  end
end
