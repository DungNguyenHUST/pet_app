class AddManagerScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :manager_score, :integer
  end
end
