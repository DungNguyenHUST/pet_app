class ChangeEmailInUser < ActiveRecord::Migration[6.1]
  def change
    def up
      change_column :users, :email, null: false, default: ""
      change_column :users, :encrypted_password, null: false, default: ""
    end
    
    def down
      change_column :users, :email, :string
      change_column :users, :encrypted_password, :string
    end
  end
end
