class AddCompanyIdToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :company_id, :integer
  end
end
