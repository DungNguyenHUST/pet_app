class CompanyJobsController < ApplicationController
    def index 
        @companie_all = Company.all
        @company_job_all = CompanyJob.all
        @companies = Company.search(params[:search])
        @company_jobs = CompanyJob.search(params[:search])
        
        # find company which incude job
        @company_by_jobs = []
        @companie_all.each do |company|
            @company_jobs.each do |company_job|
                if company.id = company_job.company_id
                    @company_by_jobs.push(company)
                end
            end
        end
    end

    def new
        @company = Company.find(params[:company_id])
        @company_job = CompanyJob.new
    end

    def create
        @company = Company.find(params[:company_id])

        @company_job = @company.company_jobs.build(company_job_param)

        if @company_job.save
            redirect_to company_path(@company)
        else
            flash[:danger] = "Lỗi, hay điền đủ nội dung có dấu *?"
            # render :new
        end
    end

    def edit
        @company = Company.find params[:company_id]
        @company_job = @company.company_jobs.find(params[:id])
    end

    def update
        @company = Company.find params[:company_id]
        @company_job = @company.company_jobs.find(params[:id])
        if(@company_job.update(company_job_param))
            redirect_to pages_path
        else
            flash[:danger] = "Không thể cập nhật thông tin"
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:id])
        @company_job.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:id])
    end

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :requirement , :benefit, :salary, :quantity, :category, :search)
    end
end
