class CompanyApplyJobsController < ApplicationController
    include ApplicationHelper
    include CompanyJobsHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_apply_jobs = @company_jobs.company_apply_jobs.order('created_at DESC')
    end

    def new
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_apply_job = CompanyApplyJob.new
    end

    def create
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_apply_job = @company_job.company_apply_jobs.build(company_apply_job_param)
        if user_signed_in?
            @company_apply_job.user_id = current_user.id
        end

        if @company_apply_job.save!
            if(find_owner_employer(@company_job).present?)
                EmployerNotificationsController.new.create_notify(find_owner_employer(@company_job), 
                                                                current_user, 
                                                                @company_job.title, 
                                                                @company_apply_job.email, 
                                                                company_job_company_apply_job_path(@company_job, @company_apply_job), 
                                                                "ApplyJob")
            end
            flash[:success] = I18n.t(:apply_job_success)
            redirect_to company_job_path(@company_job)
        else
            flash[:error] = I18n.t(:create_error)
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_apply_job = @company_job.company_apply_jobs.find(params[:id])

        @company_apply_job.destroy
        redirect_to company_job_path(@company_job)
    end

    def show
        @company_job = CompanyJob.friendly.find(params[:company_job_id])
        @company = find_company_of_job(@company_job)
        @company_apply_job = @company_job.company_apply_jobs.find(params[:id])
    end

    private

    def company_apply_job_param
        params.require(:company_apply_job).permit(:name, :email, :cover_letter, :cover_vitate, :phone, :address)
    end
end
