class ApplicationController < ActionController::Base
    protect_from_forgery
    include ::SessionHelper
    helper ActionText::Engine.helpers
    before_action :configure_permitted_parameters, if: :devise_controller?

    # before_action :require_login

    def require_login
        unless user_signed_in?
            redirect_to new_user_session_path
        end
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_in) do |user_params|
            user_params.permit( :email, :password, :password_confirmation)
        end
        devise_parameter_sanitizer.permit(:sign_up) do |user_params|
            user_params.permit( :email, :password, :password_confirmation)
        end
        devise_parameter_sanitizer.permit(:account_update) do |user_params|
            user_params.permit( :email, :password, :password_confirmation)
        end
    end
end

