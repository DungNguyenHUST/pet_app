class AddUserNameToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :user_name, :string
  end
end
