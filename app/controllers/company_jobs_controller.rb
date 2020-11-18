class CompanyJobsController < ApplicationController
    def index 
        @companie_all = Company.all
        @company_job_all = CompanyJob.all
        @companies = Company.search(params[:search])
        @company_jobs = CompanyJob.search(params[:search])
        @company_by_jobs = Company.includes(:company_jobs).all
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
        params.require(:company_job).permit(:title, :location, :description, :requirement , :benefit, :salary, :quantity, :category, :search)
    end
end
