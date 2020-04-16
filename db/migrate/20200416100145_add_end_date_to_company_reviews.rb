class AddEndDateToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :end_date, :datetime
  end
end
