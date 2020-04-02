class CreateHeaders < ActiveRecord::Migration[6.0]
  def change
    create_table :headers do |t|
      t.string :logoImage
      t.string :buttonName
      t.text :searchIcon

      t.timestamps
    end
  end
end
