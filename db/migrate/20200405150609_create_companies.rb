class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :image
      t.string :location
      t.string :website

      t.timestamps
    end
  end
end
ompanys