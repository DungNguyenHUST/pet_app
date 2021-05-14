class AddReadedToUserNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :user_notifications, :readed, :boolean, default: false
  end
end
