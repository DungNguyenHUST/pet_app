class CreateCompanyReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :company_reviews do |t|
      t.string :companyName
      t.integer :score

      t.timestamps
    end
  end
end
