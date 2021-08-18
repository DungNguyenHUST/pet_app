class CreateCompanyReactInterviews < ActiveRecord::Migration[6.1]
  def change
    create_table :company_react_interviews do |t|
      t.integer "user_id"
      t.integer "react_type", :default => -1
      t.references :company_interview, null: false, foreign_key: true

      t.timestamps
    end
  end
end
