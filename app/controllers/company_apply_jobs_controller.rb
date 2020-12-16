class CompanyApplyJobsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_jobs = @company.company_jobs
        @company_apply_jobs = @company_jobs.company_apply_jobs
    end

    def new
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_apply_job = CompanyApplyJob.new
    end

    def create
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.build(company_apply_job_param)
        @company_apply_job.user_id = current_user.id

        if @company_apply_job.save
            redirect_to company_path(@company)
        else
            flash[:danger] = "Lỗi, Không thể trả lời *?"
            # render :new
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.find(params[:id])

        @company_apply_job.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_job = @company.company_jobs.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.find(params[:id])
    end

    private

    def company_apply_job_param
        params.require(:company_apply_job).permit(:name, :email, :cover_letter, :cover_vitate)
    end
end
