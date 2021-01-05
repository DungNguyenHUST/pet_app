class AddWokingTimeToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :working_time, :string
  end
end
