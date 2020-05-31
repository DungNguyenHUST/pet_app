class AddWorkEnvScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :work_env_score, :integer
  end
end
