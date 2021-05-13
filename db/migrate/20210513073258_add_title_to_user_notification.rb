class AddTitleToUserNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :user_notifications, :title, :string
  end
end
