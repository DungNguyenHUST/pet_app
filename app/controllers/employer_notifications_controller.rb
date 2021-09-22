class EmployerNotificationsController < ApplicationController
	before_action :require_employer_login, only: [:index, :show, :edit, :update, :destroy]

	def index 
		@employer = current_employer
		@employer_notifications = @employer.employer_notifications
	end

	def new
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_notification = EmployerNotification.new
	end

	def create
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_notification = @employer.employer_notifications.build(employer_notification_param)
		@employer_notification.save
	end

	def create_notify(destination_employer, trigger_employer, title, content, original_url, noti_type)
		@employer_notification = destination_employer.employer_notifications.build(:trigger_user_id => trigger_employer.id, 
																				:title => title, 
																				:content => content, 
																				:original_url => original_url, 
																				:noti_type => noti_type)
		@employer_notification.save!
	end

	def edit
		@employer = Employer.friendly.find params[:employer_id]
		@employer_notification = @employer.employer_notifications.find(params[:id])
	end

	def update
		@employer = Employer.friendly.find params[:employer_id]
		@employer_notification = @employer.employer_notifications.find(params[:id])
		@employer_notification.update(employer_notification_param)
	end
	
	def destroy
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_notification = @employer.employer_notifications.find(params[:id])
		@employer_notification.destroy
	end

	def show
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_notification = @employer.employer_notifications.find(params[:id])
	end

	private

	def employer_notification_param
		params.require(:employer_notification).permit(:id, :employer_id, :trigger_user_id, :title, :content, :original_url, :readed, :noti_type)
	end
end
