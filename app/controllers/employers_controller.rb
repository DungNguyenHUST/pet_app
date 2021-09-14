class EmployersController < ApplicationController
    include EmployersHelper
    include CompaniesHelper
    before_action :require_employer_login, only: [:index, :show, :edit, :update, :destroy]
    
    def index
        @employers = Employer.all
    end

    def new
        @employer = Employer.new
    end
    
    def create
        @employer = Employer.new(employer_params)
    end

    def show
        @employer = current_employer

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end
        
        @company_of_employer = find_company_of_employer(@employer)
        @company_job_of_employer = find_job_of_employer(@employer).order('created_at DESC')
        @company_job_of_employer = Kaminari.paginate_array(@company_job_of_employer).page(params[:page]).per(20)
    end

    def edit
        @employer = Employer.friendly.find params[:id]
    end

    def destroy
        @employer = Employer.friendly.find params[:id]
        @employer.destroy
        redirect_to admin_path(current_admin, tab_id: 'AdminEmployerID')
    end

    def update
        @employer = Employer.friendly.find params[:id]
    end

    def wellcome
    end

    def job
        @company_job = CompanyJob.friendly.find(params[:id])
        @company_apply_jobs = @company_job.company_apply_jobs.page(params[:page]).per(20)
    end

    def plan
        @price = 0
        if(params.has_key?(:price))
            @price = params[:price].to_i * 1000

            # for cal price mode
            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end
    
    private

    def employer_params
        params.require(:employer).permit :name, :email, :password, :password_confirmation, :phone, :address, :avatar, :company_name, :company_id, :company_field, :approved
    end
end
