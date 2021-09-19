class CreateUserCertificates < ActiveRecord::Migration[6.1]
  def change
    create_table :user_certificates do |t|
      t.references :user, null: false, foreign_key: true
      t.string "cert_name"
      t.string "cert_summary"
      t.datetime "start_date"
      t.datetime "end_date"

      t.timestamps
    end
  end
end
