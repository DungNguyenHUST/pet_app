class AddColToCv < ActiveRecord::Migration[6.1]
  def change
    add_column :cover_vitaes, :origin_id, :integer
    add_column :cover_vitaes, :primary, :boolean, :default => false
    add_column :cover_vitaes, :slug, :string
    add_index :cover_vitaes, :slug, unique: true
  end
end
