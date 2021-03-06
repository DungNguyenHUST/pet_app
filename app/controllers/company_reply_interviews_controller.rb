class CompanyReplyInterviewsController < ApplicationController
    include ApplicationHelper
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_interviews = @company.company_interviews
        @company_reply_interviews = @company_interviews.company_reply_interviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_reply_interview = CompanyReplyInterview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_reply_interview = @company_interview.company_reply_interviews.build(company_reply_interview_param)
        @company_reply_interview.user_name = current_user.name
        @company_reply_interview.user_id = current_user.id

        if @company_reply_interview.save
            if(find_owner_user(@company_interview).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@company_interview), current_user, @company_interview.position, @company_reply_interview.reply_content, company_path(@company, tab_id: 'CompanyInterviewsID'), "InterviewComment")
            end
            # redirect_to company_path(@company, tab_id: 'CompanyInterviewsID')
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_reply_interview = @company_interview.company_reply_interviews.friendly.find(params[:id])

        @company_reply_interview.destroy
        redirect_to company_path(@company, tab_id: 'CompanyInterviewsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_reply_interview = @company_interview.company_reply_interviews.friendly.find(params[:id])
    end

    private

    def company_reply_interview_param
        params.require(:company_reply_interview).permit(:reply_content)
    end
end
