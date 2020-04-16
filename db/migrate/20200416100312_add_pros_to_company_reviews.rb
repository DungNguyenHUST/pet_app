class AddProsToCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_reviews, :pros, :text
  end
end
