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
            # JobCrawler.process(@scrap_job)
            # CrawlerJob.perform_later(@scrap_job.id)
            redirect_to admin_path(current_admin, tab: 'AdminScrapJobID')
        end
    end

    def pull_all
        ScrapJob.all.approved.each do |scrap_job|
            CrawlerJob.perform_later(scrap_job.id)
        end
    end

    def processing
        if Rails.env.development?
            if params.has_key?(:id)
                @scrap_job = ScrapJob.find params[:id]
                if @scrap_job
                    # JobCrawler.process(@scrap_job)
                    CrawlerJob.perform_later(@scrap_job.id)
                    flash[:success] = "Add Scrap successed ..............."
                end
            else
                self.pull_all
                flash[:success] = "Scrap all site ..............."
            end
        else
            flash[:error] = "In Production mode ..............."
        end

        redirect_to admin_path(current_admin, tab: 'AdminScrapJobID')
    end

    def push_all
        datetime = Time.now.strftime("%d%m%Y")
        filedir = "tmp/jobs/#{datetime}"

        if File.directory?(filedir)
            Dir.glob("#{filedir}/*").each do |file|
                begin
                    print "%%%%%%%%%%%%%%%%%%%%%%%Start push #{file}%%%%%%%%%%%%%%%%%%%%%"
                    filename = "#{file}"
                    csv_text = File.read(filename.to_s)
                    csv = CSV.parse(csv_text, :headers => true)
                    csv.each do |row|
                        job_data = row.to_hash
                        if job_data["apply_site"].present?
                            unless job_exsit = CompanyJob.find_by(apply_site: job_data["apply_site"])
                                print "*********Create new job*********\n"
                                @company_job = CompanyJob.new(job_data)
                                @company_job.save!
                            else
                                print "*********Duplicate data -> Update*********\n"
                                job_exsit.update!(:company_id => job_data["company_id"],
                                                    :title => job_data["title"],
                                                    :detail => job_data["detail"],
                                                    :location => job_data["location"],
                                                    :salary => job_data["salary"],
                                                    :salary_max => job_data["salary_max"],
                                                    :salary_min => job_data["salary_min"],
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
                    print "%%%%%%%%%%%%%%%%%%%%%%%End push #{file}%%%%%%%%%%%%%%%%%%%%%"
                rescue
                    print "*****************Handle file error #{file}*******************\n"
                end
            end
        end
    end

    def push
        # self.push_all
        PushingJob.perform_later
        flash[:success] = "Job push successed all"
        redirect_to admin_path(current_admin, tab: 'AdminScrapJobID')
    end

    def destroy
        @scrap_job = ScrapJob.find params[:id]
        @scrap_job.destroy
        redirect_to admin_path(current_admin, tab: 'AdminScrapJobID')
    end

    def edit
        @is_edit = params[:is_edit]
        @scrap_job = ScrapJob.find params[:id]
    end
    
    def update
        @scrap_job = ScrapJob.find(params[:id])

        if(@scrap_job.update(scrap_job_param))
            flash[:success] = I18n.t(:update_success)
        else
            flash[:danger] = I18n.t(:update_error)
        end
        redirect_to admin_path(current_admin, tab: 'AdminScrapJobID')
    end

    def scrap_job_param
        params.require(:scrap_job).permit(:id, :company_id, :company_name, :location, :url, :page_num, :proxy, :approved)
    end
end
