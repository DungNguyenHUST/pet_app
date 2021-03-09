class AddSlugToCompanyReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :company_reviews, :slug, :string
    add_index :company_reviews, :slug, unique: true
  end
end
