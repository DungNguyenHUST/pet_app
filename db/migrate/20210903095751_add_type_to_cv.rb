class AddTypeToCv < ActiveRecord::Migration[6.1]
  def change
    add_column :cover_vitaes, :sample, :boolean, :default => false
    add_column :cover_vitaes, :user_id, :integer
  end
end
