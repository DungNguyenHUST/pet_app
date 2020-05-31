class AddCareerScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :career_score, :integer
  end
end
