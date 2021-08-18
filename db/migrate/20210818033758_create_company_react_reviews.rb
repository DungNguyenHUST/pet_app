class CreateCompanyReactReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :company_react_reviews do |t|
      t.integer "user_id"
      t.integer "react_type", :default => -1
      t.references :company_review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
