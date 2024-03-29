class CompanySaveJobsController < ApplicationController
    include CompanyJobsHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
        
    def index 
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_save_job = @company_job.company_save_jobs
    end

    def new
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_save_job = CompanySaveJob.new
    end

    def create
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_save_job = CompanySaveJob.new
        @type_param = params[:type_param]

        if !already_saved?      
            @company_save_job = @company_job.company_save_jobs.create(user_id: current_user.id)
        end

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
        @company = find_company_of_job(@company_job)
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
        @company_save_job.destroy
        @type_param = params[:type_param]

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_save_job = @company_job.company_save_jobs.find(params[:id])
    end

    private

    def already_saved?
        CompanySaveJob.where(user_id: current_user.id, company_job_id: params[:company_job_id]).exists?
    end
end
