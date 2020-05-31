class AddStartDateToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :start_date, :datetime
  end
end
