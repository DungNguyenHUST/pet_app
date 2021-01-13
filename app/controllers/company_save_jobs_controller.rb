class CompanySaveJobsController < ApplicationController
    # before_action :find_company_save_job
        
    def index 
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_save_job = @company_job.company_save_jobs
    end

    def new
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_save_job = CompanySaveJob.new
    end

    def create
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_save_job = CompanySaveJob.new
        if logged_in?
            if already_saved?
                flash[:notice] = "You can't save more than once"
            else              
                @company_save_job = @company_job.company_save_jobs.create(user_id: current_user.id)
                redirect_to pages_path
            end
        else
            redirect_to login_path
        end
    end

    def destroy 
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
        @company_save_job.destroy
        redirect_to page_path
    end

    def show
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
    end

    private

    def company_save_job_param
        params.require(:company_save_job).permit(:id)
    end

    def already_saved?
        CompanySaveJob.where(user_id: current_user.id, company_job_id: params[:company_job_id]).exists?
    end

    def find_company_save_job
        @company_job = CompanyJob.find(params[:company_job_id])
        @company_save_job = CompanySaveJob.find(params[:id])
    end
end
