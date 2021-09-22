class UsersController < ApplicationController
    # skip_before_action :require_user_login, only: [:new, :create]
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy, :profile]
    
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

        # User applied job
        @company_job_saved = []
        job_saves = CompanySaveJob.where(user_id: current_user.id)
        job_saves.each do |job_save|
            @company_job_saved.push(job_save.company_job)
        end
        @company_job_saved = Kaminari.paginate_array(@company_job_saved).page(params[:page]).per(10)

        # User save job
        @company_job_applied = []
        job_applies = CompanyApplyJob.where(user_id: current_user.id)
        job_applies.each do |job_apply|
            @company_job_applied.push(job_apply.company_job)
        end
        @company_job_applied = Kaminari.paginate_array(@company_job_applied).page(params[:page]).per(10)

        # Company folow by user
        @company_followed = []
        company_follows = CompanyFollow.where(user_id: current_user.id)
        company_follows.each do |company_follow|
            @company_followed.push(company_follow.company)
        end
        @company_followed = Kaminari.paginate_array(@company_followed).page(params[:page]).per(12)

        # User notification
        @user_notifications = @user.user_notifications.page(params[:page]).per(20)

        # Problem create by user
        @problem_created = Problem.where(user_id: current_user.id)
        @problem_created = @problem_created.page(params[:page]).per(12)

        # CV create by user
        @cv_created = CoverVitae.where(user_id: current_user.id).order('created_at DESC')
        @cv_created = @cv_created.page(params[:page]).per(12)
    end

    def edit
        @user = User.friendly.find params[:id]
    end

    def destroy
        @user = User.friendly.find params[:id]
        @user.destroy
        redirect_to admin_path(current_admin, tab_id: 'AdminUserID')
    end

    def update
        @user = User.friendly.find params[:id]

        if(@user.update(user_params))
            # redirect_to user_path(current_user)
            # flash[:success] = "Update thông tin thành công"
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def profile
        @user = current_user
    end

    def preview
        # for preview mode
        @user = User.friendly.find params[:id]
        
        respond_to do |format|
            format.html {}
            format.js
        end
    end
    
    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :address, :cover_letter, 
                                    :cover_letter_attach, :avatar, :wall_picture, :first_name, :last_name,:birthday,
                                    :sex, :matrimony, :headline, :summary, :highest_education, :highest_career, :finding_job, :public)
    end
end
