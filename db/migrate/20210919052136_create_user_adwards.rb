class CreateUserAdwards < ActiveRecord::Migration[6.1]
  def change
    create_table :user_adwards do |t|
      t.references :user, null: false, foreign_key: true
      t.string "adward_name"
      t.string "adward_summary"
      t.datetime "receive_date"

      t.timestamps
    end
  end
end
