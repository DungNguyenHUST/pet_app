class CompanyDislikeInterviewsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_dislike_interviews = @company_interview.company_dislike_interviews
    end

    def new
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_dislike_interview = CompanyDislikeInterview.new
    end

    def create
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        if already_liked?
            # flash[:notice] = "You can't dislike more than once"
        else
            @company_dislike_interview = @company_interview.company_dislike_interviews.create(user_id: current_user.id)
        end
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_dislike_interview = @company_interview.company_dislike_interviews.find(params[:id])

        @company_dislike_interview.destroy
        respond_to do |format|
            format.html {}
            format.js
        end
        # redirect_to company_path(@company)
    end

    def show
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_dislike_interview = @company_interview.company_dislike_interviews.find(params[:id])
    end

    private

    def already_liked?
        CompanyDislikeInterview.where(user_id: current_user.id, company_interview_id: params[:company_interview_id]).exists?
    end
end
