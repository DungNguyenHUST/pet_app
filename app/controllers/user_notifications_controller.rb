class UserNotificationsController < ApplicationController
  def index 
    @users = User.all
    @user_notifications = UserNotification.all
  end

  def new
    @user = User.friendly.find(params[:user_id])
    @user_notification = UserNotification.new
  end

  def create
    @user = User.friendly.find(params[:user_id])
    @user_notification = @user.user_notifications.build(user_notification_param)
    @user_notification.save
  end

  def create_notify(destination_user, trigger_user, title, content, original_url, noti_type)
    @user_notification = destination_user.user_notifications.build(:trigger_user_id => trigger_user.id, :title => title, :content => content, :original_url => original_url, :noti_type => noti_type)
    @user_notification.save!
  end

  def edit
    @user = User.friendly.find params[:user_id]
    @user_notification = @user.user_notifications.find(params[:id])
  end

  def update
    @user = User.friendly.find params[:user_id]
    @user_notification = @user.user_notifications.find(params[:id])
    @user_notification.update(user_notification_param)
  end
  
  def destroy
    @user = User.friendly.find(params[:user_id])
    @user_notification = @user.user_notifications.find(params[:id])
    @user_notification.destroy
  end

  def show
    @user = User.friendly.find(params[:user_id])
    @user_notification = @user.user_notifications.find(params[:id])
  end

  private

  def user_notification_param
    params.require(:user_notification).permit(:id, :user_id, :trigger_user_id, :title, :content, :original_url, :readed, :noti_type)
  end
end
