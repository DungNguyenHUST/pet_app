class SessionsController < ApplicationController

    # skip_before_action :require_login, only: [:new, :create]
    
    def new
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        
        if user && user.authenticate(params[:session][:password])
            log_in user
            redirect_to pages_path(user)
        else
            flash[:danger] = "Email và mật khẩu không chính xác, vui lòng thử lại"
            render :new
        end
    end

    def destroy
        log_out
        flash[:success] = "Bạn đã thoát"
        redirect_to login_path
    end
end
