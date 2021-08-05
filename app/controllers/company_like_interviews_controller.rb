class CompanyLikeInterviewsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_like_interviews = @company_interviews.company_like_interviews
    end

    def new
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_like_interview = CompanyLikeInterview.new
    end

    def create
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company

        if !already_liked?
            @company_like_interview = @company_interview.company_like_interviews.create(user_id: current_user.id)
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
        @company_like_interview = @company_interview.company_like_interviews.find(params[:id])
        @company_like_interview.destroy
        
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {redirect_to :back}
            format.js
        end
    end

    def show
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_like_interview = @company_interview.company_like_interviews.find(params[:id])
    end

    private

    def already_liked?
        CompanyLikeInterview.where(user_id: current_user.id, company_interview_id: params[:company_interview_id]).exists?
    end
end
