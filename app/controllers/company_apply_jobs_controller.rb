class CompanyApplyJobsController < ApplicationController
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_jobs = @company.company_jobs
        @company_apply_jobs = @company_jobs.company_apply_jobs
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_apply_job = CompanyApplyJob.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.build(company_apply_job_param)
        @company_apply_job.user_id = current_user.id

        if @company_apply_job.save
            flash[:success] = "Thông tin của bạn đã được tiếp nhận và gửi tới nhà tuyển dụng..."
            redirect_to company_path(@company)
        else
            flash[:error] = "Lỗi, Không thể upload thông tin "
            render :new
        end
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.friendly.find(params[:id])

        @company_apply_job.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.friendly.find(params[:id])
    end

    private

    def company_apply_job_param
        params.require(:company_apply_job).permit(:name, :email, :cover_letter_rich_text, :cover_vitate)
    end
end
