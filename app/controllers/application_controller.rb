class ApplicationController < ActionController::Base
    protect_from_forgery
    include SessionHelper
    helper ActionText::Engine.helpers
    before_action :configure_permitted_parameters, if: :devise_controller?

    def require_user_login
        unless user_signed_in? || admin_signed_in?
            redirect_to new_user_session_path
        end
    end

    def require_employer_login
        unless employer_signed_in? || admin_signed_in?
            redirect_to new_employer_session_path
        end
    end

    def require_admin_login
        unless admin_signed_in?
            redirect_to new_admin_session_path
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

    # I18n config
    # around_action :switch_locale

    # def switch_locale(&action)
    #     locale = params[:locale] || I18n.default_locale
    #     I18n.with_locale(locale, &action)
    # end

    before_action :set_locale
    def set_locale
        # explicit param can always override existing setting
        # otherwise, make sure to allow a user preference to override any automatic detection
        # then detect by location, and header
        # if all else fails, fall back to default
        # I18n.locale = params[:locale] || user_pref_locale || session[:locale] || location_detected_locale || header_detected_locale || I18n.default_locale
        I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
        # save to session
        session[:locale] = I18n.locale
    end

    # these could potentially do with a bit of tidying up
    # remember to return `nil` to indicate no match

    # def user_pref_locale
    #     return nil unless current_user && current_user.locale.present?
    #     current_user.locale
    # end

    # def location_detected_locale
    #     location = request.location
    #     return nil unless location.present? && location.country_code.present? && I18n.available_locales.include?(location.country_code)
    #     location.country_code.include?("-") ? location.country_code : location.country_code.downcase
    # end

    # def header_detected_locale
    #     return nil unless (request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first.present? && I18n.available_locales.include?((request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first)
    #     (request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first
    # end

    def default_url_options
        { locale: I18n.locale }
    end
end

