class CompanySalarysController < ApplicationController
    before_action :require_login, only: [:edit, :update, :destroy]
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_salarys = @company.company_salarys
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_salary = CompanySalary.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])

        @company_salary = @company.company_salarys.build(company_salary_param)

        if user_signed_in? && !@company_salary.privacy
            @company_salary.user_name = current_user.name
            @company_salary.user_id = current_user.id
        else
            @company_salary.user_name = "Ẩn danh"
            @company_salary.user_id = -1
        end

        @company_salary.companyName = @company.name

        # @company_salary.average_score = (@company_salary.work_env_score + @company_salary.salary_score + @company_salary.ot_score + @company_salary.manager_score + @company_salary.career_score + @company_salary.score) / 6

        if @company_salary.save
            redirect_to company_path(@company, tab_id: 'CompanysalarysID')
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
        @company_salary = @company.company_salarys.friendly.find(params[:id])
        @company_salary.destroy
        redirect_to company_path(@company, tab_id: 'CompanySalarysID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_salary = @company.company_salarys.friendly.find(params[:id])
    end

    private

    def company_salary_param
        params.require(:company_salary).permit(:company_id, :salary, :salary_currency, :salary_job, :salary_experience, :salary_working_status, :user_id, :user_name)
    end
end
