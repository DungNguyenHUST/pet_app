class AddSalaryScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :salary_score, :integer
  end
end
