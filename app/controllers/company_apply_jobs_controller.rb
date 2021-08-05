class CompanyApplyJobsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_apply_jobs = @company_jobs.company_apply_jobs.order('created_at DESC')
    end

    def new
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_apply_job = CompanyApplyJob.new
    end

    def create
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_apply_job = @company_job.company_apply_jobs.build(company_apply_job_param)
        @company_apply_job.user_id = current_user.id

        if @company_apply_job.save!
            if(find_owner_employer(@company_job).present?)
                EmployerNotificationsController.new.create_notify(find_owner_employer(@company_job), 
                                                                current_user, 
                                                                @company_job.title, 
                                                                @company_apply_job.email, 
                                                                company_job_company_apply_job_path(@company_job, @company_apply_job), 
                                                                "ApplyJob")
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
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_apply_job = @company_job.company_apply_jobs.find(params[:id])

        @company_apply_job.destroy
        redirect_to company_path(@company, tab_id: 'CompanyJobsID')
    end

    def show
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = @company_job.company
        @company_apply_job = @company_job.company_apply_jobs.find(params[:id])
    end

    private

    def company_apply_job_param
        params.require(:company_apply_job).permit(:name, :email, :cover_letter, :cover_vitate)
    end
end
