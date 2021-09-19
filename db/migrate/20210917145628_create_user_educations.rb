class CreateUserEducations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_educations do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime "start_date"
      t.datetime "end_date"
      t.string "cert_level"
      t.string "cert_type"
      t.string "school_level"
      t.string "school_name"
      t.string "school_location"
      t.string "school_field"
      t.boolean "enrolled", :default => false
      
      t.timestamps
    end
  end
end
