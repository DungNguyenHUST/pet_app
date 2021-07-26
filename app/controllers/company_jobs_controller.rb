class CompanyJobsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @companies = Company.all.approved
        @company_jobs = CompanyJob.all.approved
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_job = CompanyJob.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.build(company_job_param)
        @company_job.user_id = current_user.id

        if current_user.admin?
            @company_job.approved = true
            @company_job.save!
            redirect_to root_path(tab_id: 'AdminCompanyID')
            return
        end

        if @company_job.save
			if @company_job.approved?
				redirect_to company_company_job_path(@company)
			else
				flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
				redirect_to company_path(@company, tab_id: 'CompanyJobsID')
			end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu "
            render :new
        end
    end

    def edit
        @is_edit = params[:is_edit]
        @company = Company.friendly.find params[:company_id]
        @company_job = @company.company_jobs.friendly.find(params[:id])
    end

    def update
        @company = Company.friendly.find params[:company_id]
        @company_job = @company.company_jobs.friendly.find(params[:id])

        if company_job_param.present? && !(company_job_param.has_key?(:approved))
            if(@company_job.update(company_job_param))
				if @company_job.approved?
					redirect_to company_company_job_path(@company)
				else
					flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
					redirect_to company_path(@company, tab_id: 'CompanyJobsID')
				end
			else
				flash[:danger] = "Không thể cập nhật thông tin"
			end
        else
            if (!@company_job.approved? && @company_job.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to user_path(current_user, tab_id: 'AdminCompanyID')
            elsif (@company_job.approved? && @company_job.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to user_path(current_user, tab_id: 'AdminCompanyID')
            end
		end
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:id])
        @company_job.destroy
        redirect_to company_path(@company, tab_id: 'CompanyJobsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:id])
        @company_jobs = @company.company_jobs.order('created_at DESC').approved.page(params[:page]).per(10)
    end
	
	def list
        @companies = Company.all.approved
		@company_jobs = CompanyJob.all.order('created_at DESC').approved.page(params[:page]).per(10)
		
		@is_job_searched = false
		if(params.has_key?(:search) && params.has_key?(:location))
			@is_job_searched = true
			@search = params[:search]
			@location = params[:location]
			@job_searchs = CompanyJob.friendly.search_advance(@search, @location).approved.page(params[:page]).per(12)
		end
    end

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :benefit, :requirement, :salary, :quantity, :category, :search, :end_date, :language, :level, :job_type, :urgent, :apply_another_site_flag, :apply_site, :address, {:skill => []})
    end
end
