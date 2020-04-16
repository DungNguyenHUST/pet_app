class AddPositionToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :position, :string
  end
end
