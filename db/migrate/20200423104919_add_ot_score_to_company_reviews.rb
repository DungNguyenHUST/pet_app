class AddOtScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :ot_score, :integer
  end
end
