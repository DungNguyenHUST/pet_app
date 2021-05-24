class CompanySalariesController < ApplicationController
    before_action :require_login, only: [:edit, :update, :destroy]
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

        if user_signed_in? && !@company_salary.privacy
            @company_salary.user_name = current_user.name
            @company_salary.user_id = current_user.id
        else
            @company_salary.user_name = "Ẩn danh"
            @company_salary.user_id = -1
        end

        if @company_salary.save
            redirect_to company_path(@company, tab_id: 'CompanySalariesID')
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*' "
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_salary = @company.company_salaries.friendly.find(params[:id])
        @company_salary.destroy
        redirect_to company_path(@company, tab_id: 'CompanySalariesID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_salary = @company.company_salaries.friendly.find(params[:id])
    end

    private

    def company_salary_param
        params.require(:company_salary).permit(:privacy, :company_id, :salary, :salary_currency, :salary_job, :salary_experience, :salary_working_status, :user_id, :user_name, :salary_bonus, :level, :position, :locate)
    end
end
