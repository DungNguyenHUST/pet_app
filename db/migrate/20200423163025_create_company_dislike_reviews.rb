class CreateCompanyDislikeReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :company_dislike_reviews do |t|
      t.references :company_review, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
