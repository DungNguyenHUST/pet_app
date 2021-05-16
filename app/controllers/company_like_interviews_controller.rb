class CompanyLikeInterviewsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    before_action :find_company_interview
    before_action :find_like, only: [:destroy]
    
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_interviews = @company.company_interviews
        @company_like_interviews = @company_interviews.company_like_interviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_like_interview = CompanyLikeInterview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_interview = CompanyInterview.friendly.find(params[:company_interview_id])
        if already_liked?
            # flash[:notice] = "You can't like more than once"
        else
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
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_like_interview = @company_interview.company_like_interviews.find(params[:id])
        @company_like_interview.destroy
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {redirect_to :back}
            format.js
        end
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:company_interview_id])
        @company_like_interview = @company_interview.company_like_interviews.find(params[:id])
    end

    private

    def company_like_interview_param
        # params.require(:company_like_interview).permit(:like_content)
    end

    def already_liked?
        CompanyLikeInterview.where(user_id: current_user.id, company_interview_id: params[:company_interview_id]).exists?
    end

    def find_company_interview
        @company_interview = CompanyInterview.friendly.find(params[:company_interview_id])
    end

    def find_like
        @like = @company_interview.company_like_interviews.find(params[:id])
    end
end
