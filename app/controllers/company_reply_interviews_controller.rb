class CompanyReplyInterviewsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]

    def index 
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_reply_interviews = @company_interview.company_reply_interviews
    end

    def new
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_reply_interview = CompanyReplyInterview.new
    end

    def create
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_reply_interview = @company_interview.company_reply_interviews.build(company_reply_interview_param)

        if user_signed_in?
            @company_reply_interview.user_name = current_user.name
            @company_reply_interview.user_id = current_user.id
        end

        if @company_reply_interview.save
            if(find_owner_user(@company_interview).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@company_interview), 
                                                                current_user, 
                                                                @company_interview.position, 
                                                                @company_reply_interview.reply_content, 
                                                                company_path(@company, tab: 'CompanyInterviewsID'), 
                                                                "InterviewComment")
            end

            # redirect_to company_path(@company, tab: 'CompanyInterviewsID')
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = I18n.t(:create_error)
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_reply_interview = @company_interview.company_reply_interviews.find(params[:id])

        @company_reply_interview.destroy
        redirect_to company_path(@company, tab: 'CompanyInterviewsID')
    end

    def show
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_reply_interview = @company_interview.company_reply_interviews.find(params[:id])
    end

    private

    def company_reply_interview_param
        params.require(:company_reply_interview).permit(:reply_content)
    end
end
