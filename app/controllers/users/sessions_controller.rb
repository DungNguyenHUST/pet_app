# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :save_my_previous_url, only: [:new]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if current_user.employer? && !current_user.approved?
      flash[:danger] = "Tài khoản nhà tuyển dụng của bạn đang được xử lý, vui lòng đăng nhập lại sau 30 min..."
      redirect_to pages_path
    else
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
    return
    # super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def save_my_previous_url
    session[:my_previous_url] = URI(request.referer || '').path
  end
end
