class AddEmployerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :employer, :boolean, default: false
  end
end
