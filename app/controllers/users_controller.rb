class UsersController < ApplicationController

    # skip_before_action :require_login, only: [:new, :create]
    
    def index
        @users = User.all
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new user_params
        if @user.password == @user.password_confirmation
            if @user.save
                flash[:success] = "Đăng kí thành công"
                redirect_to sessions_new_path
            else
                flash[:danger] = "Email này đã được đăng ký, hãy đăng nhập hoặc thử một email khác"
                render :new
            end
        else
            flash[:danger] = "Mật khẩu không khớp, vui lòng nhập lại"
            render :new
        end
    end

    def show
        @user = User.find_by id: params[:id]
    end

    def edit
        @user = User.find params[:id]
    end

    def destroy
        @user = User.find params[:id]
        @user.destroy
    end

    def update
        @user = User.find params[:id]
        if(@user.update(user_params))
            flash[:success] = "Update thành công"
            redirect_to user_path(current_user)
        else
            flash[:danger] = "Không thể update thông tin, vui lòng thử lại"
        end
    end
    
    private
    def user_params
        params.require(:user).permit :name, :email, :password, :password_confirmation, :phone, :address, :cover_letter , :cover_letter_attach, :avatar, :root, :admin, :user
    end
end
