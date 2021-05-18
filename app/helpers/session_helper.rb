module SessionHelper

    # def log_in user
    #     session[:user_id] = user.id
    # end

    # def log_out
    #     session.delete :user_id
    #     current_user = nil
    # end

    # get current user ID
    # def current_user
    #     if session[:user_id]
    #         current_user ||= User.friendly.find_by(id: session[:user_id])
    #     end
    # end

    # Check user has logged in before ? 
    # def user_signed_in?
    #     current_user.present?
    # end

    # def current_user?(user)
    #     user == current_user
    # end

    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
    
end
