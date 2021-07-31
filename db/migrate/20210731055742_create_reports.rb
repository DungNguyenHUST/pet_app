class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer "user_id"
      t.string "target_type"
      t.integer "target_id"
      t.integer "report_type"
      t.text "report_content"
      t.timestamps
    end
  end
end
