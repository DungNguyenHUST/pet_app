# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    before_action :save_my_previous_url, only: [:new]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    # The path used after sign in.
    def after_sign_in_path_for(resource_or_scope)
        if (session[:my_previous_url].to_s == new_user_session_path || 
            session[:my_previous_url].to_s == user_session_path || 
            session[:my_previous_url].to_s == destroy_user_session_path || 
            session[:my_previous_url].to_s == user_facebook_omniauth_authorize_path || 
            session[:my_previous_url].to_s == user_facebook_omniauth_callback_path || 
            session[:my_previous_url].to_s == user_google_oauth2_omniauth_authorize_path || 
            session[:my_previous_url].to_s == user_google_oauth2_omniauth_callback_path || 
            session[:my_previous_url].to_s == new_user_password_path || 
            session[:my_previous_url].to_s == edit_user_password_path || 
            session[:my_previous_url].to_s == user_password_path || 
            session[:my_previous_url].to_s == cancel_user_registration_path || 
            session[:my_previous_url].to_s == new_user_registration_path || 
            session[:my_previous_url].to_s == edit_user_registration_path || 
            session[:my_previous_url].to_s == user_registration_path || 
            session[:my_previous_url].to_s == users_path || 
            session[:my_previous_url].to_s == new_user_path || 
            session[:my_previous_url].to_s == edit_user_path(current_user) || 
            session[:my_previous_url].to_s == user_path(current_user))
            
            session[:my_previous_url] = root_path
        end

        stored_location_for(resource_or_scope) || session[:my_previous_url]
    end

    def save_my_previous_url
        session[:my_previous_url] = URI(request.referer || '').path
    end
end
