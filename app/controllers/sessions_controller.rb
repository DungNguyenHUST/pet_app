class SessionsController < ApplicationController

    # skip_before_action :require_login, only: [:new, :create]
    before_action :save_my_previous_url, only: [:new]
    
    def new
    end

    def create
        user = User.friendly.find_by(email: params[:session][:email].downcase)
        if user.present?
            if user.authenticate(params[:session][:password])
                if user.employer? && !user.approved?
                    flash[:danger] = "Tài khoản nhà tuyển dụng của bạn đang được xử lý, vui lòng đăng nhập lại sau 30 min..."
                    redirect_to pages_path
                else
                    log_in user

                    case session[:my_previous_url]
                    when new_user_session_path
                        redirect_to pages_path
                    when new_user_path
                        redirect_to pages_path
                    when users_path
                        redirect_to pages_path
                    else 
                        redirect_to session[:my_previous_url]
                    end
                end
            else
                flash[:danger] = "Email và mật khẩu không chính xác, vui lòng thử lại với mật khẩu khác..."
                redirect_to new_user_session_path
            end
        else
            flash[:danger] = "Email của bạn chưa được đăng kí, vui lòng đăng kí tài khoản mới tại đây..."
            redirect_to new_user_path
        end
    end

    def destroy
        log_out
        flash[:danger] = "Bạn đã thoát, hãy đăng nhập lại để tiếp tục sử dụng dịch vụ..."
        redirect_to new_user_session_path
    end

    def save_my_previous_url
        session[:my_previous_url] = URI(request.referer || '').path
    end
end
