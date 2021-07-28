class UsersController < ApplicationController

    # skip_before_action :require_login, only: [:new, :create]
    before_action :require_login, only: [:index, :show, :edit, :update, :destroy]
    
    def index
        @users = User.all
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
    end

    def show
        @user = current_user

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end

        if current_user.employer?
            @users = User.all
			@companies = Company.all.approved
			@company_jobs = CompanyJob.all.approved
			@company_reviews = CompanyReview.all
			@posts = Post.all.approved
			@problems = Problem.all.approved
            @company_by_employer = current_user.company
            @company_job_by_employer = @company_by_employer.company_jobs.all
        elsif current_user.admin?
            @users = User.all.page(params[:page]).per(20)
			@companies = Company.all.page(params[:page]).per(20)
			@company_jobs = CompanyJob.all.page(params[:page]).per(20)
			@company_reviews = CompanyReview.all.page(params[:page]).per(20)
			@posts = Post.all.page(params[:page]).per(20)
			@problems = Problem.all.page(params[:page]).per(20)
        else
            @users = User.all
			@companies = Company.all.approved
			@company_jobs = CompanyJob.all.approved
			@company_reviews = CompanyReview.all
			@posts = Post.all.approved
			@problems = Problem.all.approved
            @company_apply_job_current = []
            @company_save_job_current = []

            @company_jobs.each do |company_job|
                # find job apply by current user
                if company_job.company_apply_jobs.find { |apply| apply.user_id == current_user.id}
                    @company_apply_job_current.push(company_job)
                end

                # find job save by user
                if (company_job.company_save_jobs.find { |save| save.user_id == current_user.id})
                    @company_save_job_current.push(company_job)
                end
            end

            #find all company folow by user
            @company_all = Company.all
            @company_follow_current = []
            @company_all.each do |company|
                if (company.company_follows.find { |follow| follow.user_id == current_user.id})
                    @company_follow_current.push(company)
                end
            end
        end
    end

    def edit
        @user = User.friendly.find params[:id]
    end

    def destroy
        @user = User.friendly.find params[:id]
        @user.destroy
        redirect_to root_path(tab_id: 'AdminUserID')
    end

    def update
        @user = User.friendly.find params[:id]

        if user_params.present? && !(user_params.has_key?(:approved))
			if(@user.update(user_params))
				flash[:success] = "Update thông tin thành công"
				redirect_to user_path(current_user)
			else
				flash[:danger] = "Lỗi, không thể cập nhật thông tin"
                redirect_to user_path(current_user)
			end
        else
            if (!@user.approved? && @user.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to user_path(current_user, tab_id: 'AdminUserID')
            elsif (@user.approved? && @user.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to user_path(current_user, tab_id: 'AdminUserID')
            else
                redirect_to user_path(current_user)
            end
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
