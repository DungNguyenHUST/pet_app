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
        user_present = User.friendly.find_by(email: user_params[:email].downcase)
        
        if user_present.present?
            flash[:danger] = "Email đã được đăng kí, vui lòng thử đăng nhập lại hoặc thay đổi mật khẩu... "
            redirect_to login_path
        else
            if @user.password == @user.password_confirmation
                # special admin config
                
                if @user.save
                    flash[:success] = "Đăng kí thành công"
                    redirect_to sessions_new_path
                else
                    flash[:danger] = "Đăng kí không thành công"
                    render :new
                end
            else
                flash[:danger] = "Mật khẩu không khớp, vui lòng nhập lại mật khẩu"
                render :new
            end
        end
    end

    def show
        @user = User.friendly.find_by id: params[:id]
		
        # find job apply by current user
        @company_apply_jobs = CompanyApplyJob.all
        @company_apply_job_current = []
        @company_apply_jobs.each do |company_apply_job|
            if company_apply_job.user_id = current_user.id
                @company_apply_job_current.push(company_apply_job)
            end
        end
		#############################

        #find all company folow by user 
        @company_follows = CompanyFollow.all
        @company_follow_current = []
        @company_follows.each do |company_follow|
            if company_follow.user_id = current_user.id
                @company_follow_current.push(company_follow)
            end
        end
		#############################
		
		# find job save by user
		@company_save_jobs = CompanySaveJob.all
		@company_save_job_current = []
		@company_save_jobs.each do |company_save_job|
			if company_save_job.user_id = current_user.id
				@company_save_job_current.push(company_save_job)
			end
		end
		#############################
		
    end

    def edit
        @user = User.friendly.find params[:id]
    end

    def destroy
        @user = User.friendly.find params[:id]
        @user.destroy
        redirect_to pages_path
    end

    def update
        @user = User.friendly.find params[:id]

        if user_params.present? && !(user_params.has_key?(:approved))
			if(@user.update(user_params))
				flash[:success] = "Update thành công"
				redirect_to user_path(current_user)
			else
				flash[:danger] = "Không thể update thông tin, vui lòng thử lại"
			end
        else
            if (!@user.approved? && @user.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to pages_path
            elsif (@user.approved? && @user.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to pages_path
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
