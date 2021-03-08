class SessionsController < ApplicationController

    # skip_before_action :require_login, only: [:new, :create]
    before_action :save_my_previous_url, only: [:new]
    
    def new
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            log_in user
            # flash[:success] = "Đăng nhập thành công"
            redirect_to session[:my_previous_url]
        else
            flash[:danger] = "Email và mật khẩu không chính xác, vui lòng thử lại"
            render :new
        end
    end

    def destroy
        log_out
        flash[:danger] = "Bạn đã thoát, hãy đăng nhập lại để tiếp tục sử dụng dịch vụ ..."
        redirect_to login_path
    end

    def save_my_previous_url
        session[:my_previous_url] = URI(request.referer || '').path
    end
end
