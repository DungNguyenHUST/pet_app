class CompanyDislikeInterviewsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_interviews = @company.company_interviews
        @company_dislike_interviews = @company_interviews.company_dislike_interviews
    end

    def new
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_dislike_interview = CompanyDislikeInterview.new
    end

    def create
        @company = Company.find(params[:company_id])
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        if logged_in?
            if already_liked?
                flash[:notice] = "You can't dislike more than once"
            else
                @company_dislike_interview = @company_interview.company_dislike_interviews.create(user_id: current_user.id)
            end
            redirect_to company_path(@company)
        else
            redirect_to login_path
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_dislike_interview = @company_interview.company_dislike_interviews.find(params[:id])

        @company_dislike_interview.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_dislike_interview = @company_interview.company_dislike_interviews.find(params[:id])
    end

    private

    def company_dislike_interview_param
        # params.require(:company_dislike_interview).permit(:like_content)
    end

    def already_liked?
        CompanyDislikeInterview.where(user_id: current_user.id, company_interview_id: params[:company_interview_id]).exists?
    end
end
