class UsersController < ApplicationController
    # skip_before_action :require_user_login, only: [:new, :create]
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy]
    
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

        @company_job_applied = []
        @company_job_saved = []
        CompanyJob.all.each do |company_job|
            # find job apply by current user
            if company_job.company_apply_jobs.find { |apply| apply.user_id == current_user.id}
                @company_job_applied.push(company_job)
            end

            # find job save by user
            if (company_job.company_save_jobs.find { |save| save.user_id == current_user.id})
                @company_job_saved.push(company_job)
            end
        end
        @company_job_applied = Kaminari.paginate_array(@company_job_applied).page(params[:page]).per(12)
        @company_job_saved = Kaminari.paginate_array(@company_job_saved).page(params[:page]).per(10)

        #find all company folow by user
        @company_followed = []
        Company.all.each do |company|
            if (company.company_follows.find { |follow| follow.user_id == current_user.id})
                @company_followed.push(company)
            end
        end
        @company_followed = Kaminari.paginate_array(@company_followed).page(params[:page]).per(12)

        @user_notifications = @user.user_notifications.page(params[:page]).per(20)

        @problem_created = Problem.all.approved.find_all{ |problem| problem.user_id == current_user.id }
        @problem_created = Kaminari.paginate_array(@problem_created).page(params[:page]).per(12)
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
            redirect_to user_path(current_user)
            flash[:success] = "Update thông tin thành công"
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end
    end
    
    private
    def user_params
        params.require(:user).permit :name, :email, :password, :password_confirmation, :phone, :address, :cover_letter , :cover_letter_attach, :avatar, :root, :admin, :user, :employer, :company, :company_id
    end
end
