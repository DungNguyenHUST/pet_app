# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]
    before_action :save_my_previous_url, only: [:new]
    before_action :configure_permitted_parameters, if: :devise_controller?

    # GET /resource/sign_up
    def new
        @user_type = params[:user_type]
        super
    end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    def after_sign_up_path_for(resource_or_scope)
        case session[:my_previous_url]
        when new_user_session_path
        when user_session_path
        when destroy_user_session_path
        when user_facebook_omniauth_authorize_path
        when user_facebook_omniauth_callback_path
        when user_google_oauth2_omniauth_authorize_path
        when user_google_oauth2_omniauth_callback_path
        when new_user_password_path
        when edit_user_password_path
        when user_password_path
        when cancel_user_registration_path
        when new_user_registration_path
        when edit_user_registration_path
        when user_registration_path
        when users_path
        when new_user_path
        when edit_user_path(current_user)
        when user_path(current_user)
            session[:my_previous_url] = root_path
        else
        end

        stored_location_for(resource_or_scope) || session[:my_previous_url]
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u|
            u.permit(:name, :email, :password, :password_confirmation, :phone, :address, :cover_letter , :cover_letter_attach, :avatar, :root, :admin, :user, :employer, :company, :company_id)
        }
    end

    def save_my_previous_url
        session[:my_previous_url] = URI(request.referer || '').path
    end
end
