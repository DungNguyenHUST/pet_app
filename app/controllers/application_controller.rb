class ApplicationController < ActionController::Base
    protect_from_forgery
    include ::SessionHelper
    helper ActionText::Engine.helpers

    # before_action :require_login

    def require_login
        unless logged_in?
            redirect_to login_path
        end
    end
end

