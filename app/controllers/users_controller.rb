class UsersController < ApplicationController

    skip_before_action :require_login, only: [:new, :create]
    
    def index
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new user_params
        if @user.save
            redirect_to sessions_new_path
        else
            flash[:success] = "Tên tài khoản hoặc mật khẩu không chính xác"
            render :new
        end
    end

    def show
        @user = User.find_by id: params[:id]
    end
    
    private
    def user_params
        params.require(:user).permit :name, :password, :password_confirmation, :avatar
    end
end
