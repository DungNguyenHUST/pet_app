class CompanySalariesController < ApplicationController
    include CompaniesHelper
    before_action :require_user_login, only: [:edit, :update, :destroy]
    
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_salaries = @company.company_salaries
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_salary = CompanySalary.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_salary = @company.company_salaries.build(company_salary_param)

        if user_signed_in?
            @company_salary.user_name = current_user.name
            @company_salary.user_id = current_user.id
        end

        if @company_salary.save
            save_action_user(@company)
            redirect_to company_path(@company, tab: 'CompanySalariesID')
        else
            flash[:danger] = I18n.t(:create_error)
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_salary = @company.company_salaries.find(params[:id])
        @company_salary.destroy
        
        redirect_to company_path(@company, tab: 'CompanySalariesID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_salary = @company.company_salaries.find(params[:id])
    end

    private

    def company_salary_param
        params.require(:company_salary).permit(:privacy, :company_id, :salary, :salary_currency, :salary_job, :salary_experience, :salary_working_status, :user_id, :user_name, :salary_bonus, :level, :position, :locate)
    end
end
