class UsersController < ApplicationController
    def index
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new user_params
        if @user.save
            flash[:success] = "Register success"
            redirect_to users_path
        else
            flash[:success] = "Register failed"
            render :new
        end
    end

    def show
        @user = User.find_by id: params[:id]
    end
    
    private
    def user_params
        params.require(:user).permit :name, :password, :password_confirmation
    end
end
