class CreateEmployerNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :employer_notifications do |t|
      t.string "title"
      t.text "content"
      t.string "original_url"
      t.integer "trigger_user_id"
      t.boolean "readed", default: false
      t.string "noti_type"
      t.references :employer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
