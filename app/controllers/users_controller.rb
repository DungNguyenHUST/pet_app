class UsersController < ApplicationController

    # skip_before_action :require_login, only: [:new, :create]
    
    def index
        @users = User.all
    end

    def new
        @user = User.new
        @param = params[:role_param]
    end
    
    def create
        @user = User.new(user_params)
        if @user.password == @user.password_confirmation
            if @user.save
                flash[:success] = "Đăng kí thành công"
                redirect_to sessions_new_path
            else
                flash[:danger] = "Email này đã được đăng ký, hãy đăng nhập hoặc thử một email khác"
                render :new
            end
        else
            flash[:danger] = "Mật khẩu không khớp, vui lòng nhập lại"
            render :new
        end
    end

    def show
        @user = User.find_by id: params[:id]
        # find all apply job by current user
        @company_apply_jobs = CompanyApplyJob.all
        @company_apply_job_current = []
        @company_apply_jobs.each do |company_apply_job|
            if company_apply_job.user_id = current_user.id
                @company_apply_job_current.push(company_apply_job)
            end
        end

        # find all job of apply job by user
        @company_jobs = CompanyJob.all
        @company_job_current = []

        @company_jobs.each do |company_job|
            @company_apply_job_current.each do |company_apply_job_current|
                if company_apply_job_current.company_job_id = company_job.id
                    @company_job_current.push(company_job)
                end
            end
        end

        #find all company which include job
        @companies = Company.all
        @company_current = []

        @companies.each do |comapny|
            @company_job_current.each do |company_job_current|
                if company_job_current.company_id = comapny.id
                    @company_current.push(comapny)
                end
            end
        end

        @company_follows = CompanyFollow.all
        @company_current_follow = []
        @company_follows.each do |company_follow|
            if company_follow.user_id = current_user.id
                @company_current_follow.push(company_follow)
            end
        end

        @company_all = Company.all
        @company_current_follower = []

        @company_all.each do |company|
            @company_current_follow.each do |company_current_follow|
                if company_current_follow.company_id = company.id
                    @company_current_follower.push(company)
                end
            end
        end
    end

    def edit
        @user = User.find params[:id]
    end

    def destroy
        @user = User.find params[:id]
        @user.destroy
        redirect_to pages_path
    end

    def update
        @user = User.find params[:id]
        if(@user.update(user_params))
            flash[:success] = "Update thành công"
            redirect_to user_path(current_user)
        else
            flash[:danger] = "Không thể update thông tin, vui lòng thử lại"
        end
    end

    def try(arg)
        self[arg] rescue nil
    end
    
    private
    def user_params
        params.require(:user).permit :name, :email, :password, :password_confirmation, :phone, :address, :cover_letter , :cover_letter_attach, :avatar, :root, :admin, :user, :employer, :company, :company_id
    end
end
