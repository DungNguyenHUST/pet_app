class ScrapCompaniesController < ApplicationController
    before_action :require_admin_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index
        @scrap_companies = ScrapCompany.all
    end

    def new
        @scrap_company = ScrapCompany.new
    end

    def create
        @scrap_company = ScrapCompany.new(scrap_company_param)
        if @scrap_company.save
            redirect_to admin_path(current_admin, tab: 'AdminScrapCompanyID')
        end
    end

    def edit
        @is_edit = params[:is_edit]
        @scrap_company = ScrapCompany.find params[:id]
    end

    def update
        @scrap_company = ScrapCompany.find(params[:id])

        if(@scrap_company.update(scrap_company_param))
            flash[:success] = I18n.t(:update_success)
        else
            flash[:danger] = I18n.t(:update_error)
        end
        redirect_to admin_path(current_admin, tab: 'AdminScrapCompanyID')
    end

    def processing
        if params.has_key?(:id)
            @scrap_company = ScrapCompany.find params[:id]
            if @scrap_company
                CrawlerCompanyJob.perform_later(@scrap_company.id)
                # CompanyCrawler.process(@scrap_company)
                flash[:success] = "Add Scrap successed ..............."
            end
        else
            self.pull_all
            flash[:success] = "Scrap all site ..............."
        end

        redirect_to admin_path(current_admin, tab: 'AdminScrapCompanyID')
    end

    def pull_all
        ScrapCompany.all.approved.each do |scrap_job|
            CrawlerCompanyJob.perform_later(scrap_job.id)
        end
    end

    def push_all
        filedir = "tmp/companies/"

        if File.directory?(filedir)
            Dir.glob("#{filedir}/*").each do |file|
                print "%%%%%%%%%%%%%%%%%%%%%%%Start push #{file}%%%%%%%%%%%%%%%%%%%%%"
                filename = "#{file}"
                csv_text = File.read(filename.to_s)
                csv = CSV.parse(csv_text, :headers => true)
                csv.each do |row|
                    company_data = row.to_hash
                    if company_data["name"].present?
                        unless company_exsit = Company.find_by(name: company_data["name"])
                            print "*********Create new company*********\n"
                            @company = Company.new(company_data)

                            # Store image from remote
                            if company_data["image"]
                                tempfile = MiniMagick::Image.open(company_data["image"])
        
                                @company.avatar = tempfile
                            end

                            @company.save!
                        # else
                            # print "*********Duplicate data -> Update*********\n"
                            # @company_exsit.update!(:name => company_data["name"]
                            #                         :image => company_data["image"]
                            #                         :location => company_data["location"]
                            #                         :website => company_data["website"]
                            #                         :size => company_data["size"]
                            #                         :overview => company_data["overview"]
                            #                         :time_establish => company_data["time_establish"]
                            #                         :field_operetion => company_data["field_operetion"]
                            #                         :time_start => company_data["time_start"]
                            #                         :time_end => company_data["time_end"]
                            #                         :country => company_data["country"]
                            #                         :address => company_data["address"]
                            #                         :policy => company_data["policy"]
                            #                         :phone => company_data["phone"]
                            #                         :values => company_data["values"]
                            #                         :approved => company_data["approved"]
                            #                         :wall_picture => company_data["wall_picture"]
                            #                         :working_time => company_data["working_time"]
                            #                         :working_date => company_data["working_date"]
                            #                         :company_type => company_data["company_type"]
                            #                         :benefit => company_data["benefit"]
                            #                         :employer_id => company_data["employer_id"])
                        end
                    end   
                end
                print "%%%%%%%%%%%%%%%%%%%%%%%End push #{file}%%%%%%%%%%%%%%%%%%%%%"
            end
        end
    end

    def push
        self.push_all
        flash[:success] = "Company push successed all"
        redirect_to admin_path(current_admin, tab: 'AdminScrapCompanyID')
    end

    def scrap_company_param
        params.require(:scrap_company).permit(:id, :url, :page_num)
    end
end
