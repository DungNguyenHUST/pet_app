class CreateUserExperiences < ActiveRecord::Migration[6.1]
  def change
    create_table :user_experiences do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime "start_date"
      t.datetime "end_date"
      t.string "company_name"
      t.string "company_location"
      t.string "job_level"
      t.string "job_summary"
      t.boolean "enrolled", :default => false

      t.timestamps
    end
  end
end
