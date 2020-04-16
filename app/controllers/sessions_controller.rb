class SessionsController < ApplicationController

    skip_before_action :require_login, only: [:new, :create]
    $is_user_login = false
    
    def new
    end

    def create
        user = User.find_by name: params[:session][:name].downcase
        if user && user.authenticate(params[:session][:password])
            $is_user_login = true
            log_in user
            redirect_to pages_path(user)
        else
            flash[:danger] = "Tên tài khoản và mật khẩu email không chính xác"
            render :new
        end
    end

    def destroy
        log_out
        flash[:success] = "Bạn đã thoát"
        redirect_to login_path
    end
end
