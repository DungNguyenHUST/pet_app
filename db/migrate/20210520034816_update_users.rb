class UpdateUsers < ActiveRecord::Migration[6.1]
  def change
    unless column_exists? :users, :provider
      add_column(:users, :provider, :string, limit: 50, null: false, default: '')
    end
    unless column_exists? :users, :uid
      add_column(:users, :uid, :string, limit: 500, null: false, default: '')
    end
  end
end
