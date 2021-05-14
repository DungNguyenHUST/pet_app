class AddTriggerUserIdToUserNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :user_notifications, :trigger_user_id, :integer
  end
end
