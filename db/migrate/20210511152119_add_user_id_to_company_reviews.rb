class AddUserIdToCompanyReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :company_reviews, :user_id, :integer
  end
end
