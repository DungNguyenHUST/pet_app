class EmployersController < ApplicationController
    include EmployersHelper
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
        
        @company_by_employer = find_owner_company_for_employer(@employer)
        if(@company_by_employer.present?)
            @company_job_by_employer = @company_by_employer.company_jobs
        end
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
    
    private

    def employer_params
        params.require(:employer).permit :name, :email, :password, :password_confirmation, :phone, :address, :avatar, :company_name, :company_id, :company_field, :approved
    end
end
