class CompanyApplyJobsController < ApplicationController
    include ApplicationHelper
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_jobs = @company.company_jobs
        @company_apply_jobs = @company_jobs.company_apply_jobs.order('created_at DESC')
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

        if @company_apply_job.save!
            if(find_owner_user(@company_job).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@company_job), current_user, @company_job.title, @company_apply_job.email, pages_path(@tab_id == "JobID"), "ApplyJob")
            end
            flash[:success] = "Thông tin của bạn đã được tiếp nhận và gửi tới nhà tuyển dụng..."
            redirect_to company_path(@company, tab_id: 'CompanyJobsID')
        else
            flash[:error] = "Lỗi, Không thể upload thông tin "
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.friendly.find(params[:id])

        @company_apply_job.destroy
        redirect_to company_path(@company, tab_id: 'CompanyJobsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:company_job_id])
        @company_apply_job = @company_job.company_apply_jobs.friendly.find(params[:id])
    end

    private

    def company_apply_job_param
        params.require(:company_apply_job).permit(:name, :email, :cover_letter, :cover_vitate)
    end
end
