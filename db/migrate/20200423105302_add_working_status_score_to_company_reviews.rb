class AddWorkingStatusScoreToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :working_status, :bool
  end
end
