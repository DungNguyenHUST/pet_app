class AddOriginalUrlToUserNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :user_notifications, :original_url, :string
  end
end
