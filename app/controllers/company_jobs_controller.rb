class CompanyJobsController < ApplicationController
    def index 
        @companie_all = Company.all.approved
        @company_job_all = CompanyJob.all.approved
        @companies = Company.friendly.search(params[:search]).approved
        @company_jobs = CompanyJob.friendly.search(params[:search]).approved
        
        # find company which incude job
        @company_by_jobs = []
        @companie_all.each do |company|
            @company_jobs.each do |company_job|
				if company_job.approved?
					if (company.id = company_job.company_id)
						@company_by_jobs.push(company)
					end
				end
            end
        end
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
		if (!@company_job.approved? && @company_job.update_column(:approved, true))
			flash[:success] = "Approved"
			redirect_to pages_path
        elsif (@company_job.approved? && @company_job.update_column(:approved, false))
            flash[:danger] = "Rejected"
			redirect_to pages_path
		else
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

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :benefit, :requirement, :salary, :quantity, :category, :search, :end_date, :language, :level, :job_type, :urgent)
    end
end
