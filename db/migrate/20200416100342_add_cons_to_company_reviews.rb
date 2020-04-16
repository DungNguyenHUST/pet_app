class AddConsToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :cons, :text
  end
end
