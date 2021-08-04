class CompanySaveJobsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
        
    def index 
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_save_job = @company_job.company_save_jobs
    end

    def new
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_save_job = CompanySaveJob.new
    end

    def create
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_save_job = CompanySaveJob.new
        @type_param = params[:type_param]
        if already_saved?
            # flash[:notice] = "You can't save more than once"
        else              
            @company_save_job = @company_job.company_save_jobs.create(user_id: current_user.id)
        end
        # redirect_to company_company_job_path(@company, @company_job)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
    end

    def update
    end

    def destroy 
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
        @company_save_job.destroy
        @type_param = params[:type_param]
        # redirect_to company_company_job_path(@company, @company_job)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
    end

    private

    def company_save_job_param
        params.require(:company_save_job).permit(:id)
    end

    def already_saved?
        CompanySaveJob.where(user_id: current_user.id, company_job_id: params[:company_job_id]).exists?
    end
end
