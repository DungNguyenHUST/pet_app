class CreateEmployerBills < ActiveRecord::Migration[6.1]
  def change
    create_table :employer_bills do |t|
      t.references :employer, null: false, foreign_key: true
      t.string :bill_image
      t.boolean :confirmed, default: false
      t.bigint :total_cash, default: 0
      t.timestamps
    end
  end
end