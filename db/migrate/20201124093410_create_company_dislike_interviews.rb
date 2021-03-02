class CreateCompanyDislikeInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :company_dislike_interviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company_interview, null: false, foreign_key: true

      t.timestamps
    end
  end
end
