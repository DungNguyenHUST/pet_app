class CreateCoverVitaes < ActiveRecord::Migration[6.1]
  def change
    create_table :cover_vitaes do |t|
      t.string  "title"
      t.string  "description"
      t.text    "detail"
      t.string  "category"
      t.string  "language"
      t.string  "style"
      t.string  "avatar"

      t.timestamps
    end
  end
end
