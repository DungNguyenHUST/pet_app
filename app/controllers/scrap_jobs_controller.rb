class ScrapJobsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index
        @scrap_jobs = ScrapJob.all
    end

    def new
        @scrap_job = ScrapJob.new
    end

    def create
        @scrap_job = ScrapJob.new(scrap_job_param)
        if @scrap_job.save
            ScraperJob.perform_now(@scrap_job)
            redirect_to user_path(current_user, tab_id: 'ScrapJobID')
        end
    end

    def scrap_job_param
        params.require(:scrap_job).permit(:id, :company_id, :company_name, :location, :url)
    end
end
