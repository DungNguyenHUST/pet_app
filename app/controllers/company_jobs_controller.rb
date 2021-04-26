class CompanyJobsController < ApplicationController
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

        if @company_job.save
			if @company_job.approved?
				redirect_to company_company_job_path(@company)
			else
				flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
				redirect_to company_path(@company)
			end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu "
            render :new
        end
    end

    def edit
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
					redirect_to company_path(@company)
				end
			else
				flash[:danger] = "Không thể cập nhật thông tin"
			end
        else
            if (!@company_job.approved? && @company_job.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to pages_path
            elsif (@company_job.approved? && @company_job.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to pages_path
            end
		end
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:id])
        @company_job.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:id])
    end
	
	def list
        @companies = Company.all.approved
		@company_jobs = CompanyJob.all.approved
		
		@is_job_searched = false
		if(params.has_key?(:search) && params.has_key?(:location))
			@is_job_searched = true
			@search = params[:search]
			@location = params[:location]
			@job_searchs = CompanyJob.friendly.search_advance(@search, @location).approved
		end
    end

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :benefit, :requirement, :salary, :quantity, :category, :search, :end_date, :language, :level, :job_type, :urgent)
    end
end
