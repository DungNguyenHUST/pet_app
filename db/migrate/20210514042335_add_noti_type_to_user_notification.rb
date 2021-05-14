class AddNotiTypeToUserNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :user_notifications, :noti_type, :string
  end
end
