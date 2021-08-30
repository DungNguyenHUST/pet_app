class ScrapJobsController < ApplicationController
    before_action :require_admin_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index
        @scrap_jobs = ScrapJob.all
    end

    def new
        @scrap_job = ScrapJob.new
    end

    def create
        @scrap_job = ScrapJob.new(scrap_job_param)
        if @scrap_job.save
            JobCrawler.process(@scrap_job)
            flash[:success] = "Scrap successed ..............."
            redirect_to admin_path(current_admin, tab_id: 'ScrapJobID')
        end
    end

    def push
        csv_text = File.read('tmp/jobs/jobs.csv')
        csv = CSV.parse(csv_text, :headers => true)
        csv.each do |row|
            job_data = row.to_hash
            if job_data["apply_site"].present? && job_data["company_id"].present?
                unless job_exsit = CompanyJob.find_by(company_id: job_data["company_id"], apply_site: job_data["apply_site"])
                    CompanyJob.create!(job_data)
                else
                    print "*********Duplicate data*********\n"
                end
            end
            
        end
        flash[:success] = "Job push successed ..............."
        redirect_to admin_path(current_admin, tab_id: 'ScrapJobID')
    end

    def scrap_job_param
        params.require(:scrap_job).permit(:id, :company_id, :company_name, :location, :url)
    end
end
