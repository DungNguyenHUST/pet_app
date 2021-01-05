class AddPrivacyToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :privacy, :boolean, default: false
  end
end
