class AddContentToUserNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :user_notifications, :content, :text
  end
end
