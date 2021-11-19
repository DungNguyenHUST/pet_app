class CompanyInterviewsController < ApplicationController
    before_action :require_user_login, only: [:edit, :update, :destroy]

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

        if user_signed_in?
            @company_interview.user_name = current_user.name
            @company_interview.user_id = current_user.id
        end

        if @company_interview.save
            redirect_to company_path(@company, tab: 'CompanyInterviewsID')
        else
            flash[:error] = I18n.t(:create_error)
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:id])
        @company_interview.destroy
        redirect_to company_path(@company, tab: 'CompanyInterviewsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_interview = @company.company_interviews.find(params[:id])
    end

    private

    def company_interview_param
        params.require(:company_interview).permit(:position, :get_interview, :process , :difficultly, :satisfied , :offer, :content, :privacy)
    end
end
