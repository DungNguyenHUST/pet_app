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
        @user = current_user
		
        #############################
        @company_jobs = CompanyJob.all
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

		#############################

        #find all company folow by user 
        @company_all = Company.all
        @company_follow_current = []
        @company_all.each do |company|
            if (company.company_follows.find { |follow| follow.user_id == current_user.id})
                @company_follow_current.push(company)
            end
        end
		#############################

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end
		
    end

    def edit
        @user = User.friendly.find params[:id]
    end

    def destroy
        @user = User.friendly.find params[:id]
        @user.destroy
        redirect_to pages_path(tab_id: 'UserID')
    end

    def update
        @user = User.friendly.find params[:id]

        if user_params.present? && !(user_params.has_key?(:approved))
			if(@user.update(user_params))
				flash[:success] = "Update thông tin thành công"
				redirect_to user_path(current_user)
			else
				flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
			end
        else
            if (!@user.approved? && @user.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to pages_path(tab_id: 'UserID')
            elsif (@user.approved? && @user.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to pages_path(tab_id: 'UserID')
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
