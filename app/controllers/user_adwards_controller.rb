class UserAdwardsController < ApplicationController
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy]

    def index 
        @users = User.all
        @user_adwards = UserAdward.all
    end

    def new
        @user = User.friendly.find(params[:user_id])
        @user_adward = UserAdward.new
    end

    def create
        @user = User.friendly.find(params[:user_id])
        @user_adward = @user.user_adwards.build(user_adward_param)
        @user_adward.save

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
        @user = User.friendly.find params[:user_id]
        @user_adward = @user.user_adwards.find(params[:id])
    end

    def update
        @user = User.friendly.find params[:user_id]
        @user_adward = @user.user_adwards.find(params[:id])
        @user_adward.update(user_adward_param)

        respond_to do |format|
            format.html {}
            format.js
        end
    end
    
    def destroy
        @user = User.friendly.find(params[:user_id])
        @user_adward = @user.user_adwards.find(params[:id])
        @user_adward.destroy

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @user = User.friendly.find(params[:user_id])
        @user_adward = @user.user_adwards.find(params[:id])
    end

    private

    def user_adward_param
        params.require(:user_adward).permit(:id, :user_id, :adward_name, :receive_date, :adward_summary)
    end
end
