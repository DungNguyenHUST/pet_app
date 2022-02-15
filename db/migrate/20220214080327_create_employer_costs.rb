class CreateEmployerCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :employer_costs do |t|
      t.references :employer, null: false, foreign_key: true
      t.string "location"
      t.string "ip"
      t.string "url"
      t.bigint "cost"

      t.timestamps
    end
  end
end
