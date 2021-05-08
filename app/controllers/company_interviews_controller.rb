class CompanyInterviewsController < ApplicationController
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_interviews = @company.company_interviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_interview = CompanyInterview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])

        @company_interview = @company.company_interviews.build(company_interview_param)

        if logged_in? && !@company_interview.privacy
            @company_interview.user_name = @current_user.name
        else
            @company_interview.user_name = "Ẩn danh"
        end

        @company_interview.companyName = @company.name

        if @company_interview.save
            redirect_to company_path(@company)
        else
            flash[:error] = "Lỗi, hãy điền đủ nội dung có dấu '*' "
            render :new
        end
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:id])
        @company_interview.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.friendly.find(params[:id])
    end

    private

    def company_interview_param
        params.require(:company_interview).permit(:position, :get_interview, :process , :difficultly, :satisfied , :offer, :content, :privacy)
    end
end
