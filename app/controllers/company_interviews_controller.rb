class CompanyInterviewsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_interviews = @company.company_interviews
    end

    def new
        @company_interview = Companyinterview.new
    end

    def create
        @company = Company.find(params[:company_id])

        @company_interview = @company.company_interviews.build(company_interview_param)

        @company_interview.user_name = @current_user.name

        if @company_interview.save
            flash[:success] = "Đã lưu lại nhận xét"
            redirect_to company_company_interviews_path(@company)
        else
            flash[:danger] = "Comment lỗi?"
            # render :new
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:id])
        @company_interview.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:id])
    end

    private

    def company_interview_param
        params.require(:company_interview).permit(:user_name, :position , :content)
    end
end
