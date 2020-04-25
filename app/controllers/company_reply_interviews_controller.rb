class CompanyReplyInterviewsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_interviews = @company.company_interviews
        @company_reply_interviews = @company_interviews.company_reply_interviews
    end

    def new
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_reply_interview = CompanyReplyInterview.new
    end

    def create
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_reply_interview = @company_interview.company_reply_interviews.build(company_reply_interview_param)

        @company_reply_interview.user_name = @current_user.name

        if @company_reply_interview.save
            redirect_to company_path(@company)
        else
            flash[:danger] = "Lỗi, Không thể trả lời *?"
            # render :new
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_reply_interview = @company_interview.company_reply_interviews.find(params[:id])

        @company_reply_interview.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:company_interview_id])
        @company_reply_interview = @company_interview.company_reply_interviews.find(params[:id])
    end

    private

    def company_reply_interview_param
        params.require(:company_reply_interview).permit(:reply_content)
    end
end