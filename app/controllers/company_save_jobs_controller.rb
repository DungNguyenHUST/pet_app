class CompanySaveJobsController < ApplicationController
    # before_action :find_company_save_job
        
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_save_job = @company_job.company_save_jobs
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_save_job = CompanySaveJob.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_save_job = CompanySaveJob.new
        if logged_in?
            if already_saved?
                # flash[:notice] = "You can't save more than once"
            else              
                @company_save_job = @company_job.company_save_jobs.create(user_id: current_user.id)
            end
            redirect_to company_company_job_path(@company, @company_job)
            # respond_to do |format|
            #     format.html {}
            #     format.js
            # end
        else
            redirect_to login_path
        end
    end

    def destroy 
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
        @company_save_job.destroy
        redirect_to company_company_job_path(@company, @company_job)
        # respond_to do |format|
        #     format.html {}
        #     format.js
        # end
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
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
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company_save_job = CompanySaveJob.find(params[:id])
    end
end
