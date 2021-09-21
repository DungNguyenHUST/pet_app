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
            JobCrawlerWorker.clear_sidekiq_queue
            JobCrawlerWorker.perform_async(@scrap_job.id)
            # JobCrawler.process(@scrap_job)
            flash[:success] = "Scrap successed ..............."
            redirect_to admin_path(current_admin, tab_id: 'ScrapJobID')
        end
    end

    def push
        csv_text = File.read('tmp/jobs/jobs.csv')
        csv = CSV.parse(csv_text, :headers => true)
        csv.each do |row|
            job_data = row.to_hash
            if job_data["apply_site"].present?
                unless job_exsit = CompanyJob.find_by(apply_site: job_data["apply_site"])
                    print "*********Create new job*********\n"
                    CompanyJob.create!(job_data)
                else
                    print "*********Duplicate data -> Update*********\n"
                    job_exsit.update!(:company_id => job_data["company_id"],
                                        :title => job_data["title"],
                                        :detail => job_data["detail"],
                                        :location => job_data["location"],
                                        :salary => job_data["salary"],
                                        :quantity => job_data["quantity"],
                                        :category => job_data["category"],
                                        :language => job_data["language"],
                                        :level => job_data["level"],
                                        :dudate => job_data["dudate"],
                                        :end_date => job_data["end_date"],
                                        :typical => job_data["typical"],
                                        :urgent => job_data["urgent"],
                                        :apply_another_site_flag => job_data["apply_another_site_flag"],
                                        :apply_site => job_data["apply_site"],
                                        :address => job_data["address"],
                                        :admin_id => job_data["admin_id"],
                                        :approved => job_data["approved"],
                                        :company_name => job_data["company_name"],
                                        :company_avatar => job_data["company_avatar"],
                                        :experience => job_data["experience"])
                end
            end
            
        end
        flash[:success] = "Job push successed ..............."
        redirect_to admin_path(current_admin, tab_id: 'ScrapJobID')
    end

    def scrap_job_param
        params.require(:scrap_job).permit(:id, :company_id, :company_name, :location, :url, :page_num, :proxy)
    end
end
