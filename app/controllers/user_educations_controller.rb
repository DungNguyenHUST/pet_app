class UserEducationsController < ApplicationController
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy]

    def index 
        @users = User.all
        @user_educations = UserEducation.all
    end

    def new
        @user = User.friendly.find(params[:user_id])
        @user_education = UserEducation.new
    end

    def create
        @user = User.friendly.find(params[:user_id])
        @user_education = @user.user_educations.build(user_education_param)
        @user_education.save

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
        @user = User.friendly.find params[:user_id]
        @user_education = @user.user_educations.find(params[:id])
    end

    def update
        @user = User.friendly.find params[:user_id]
        @user_education = @user.user_educations.find(params[:id])
        @user_education.update(user_education_param)

        respond_to do |format|
            format.html {}
            format.js
        end
    end
    
    def destroy
        @user = User.friendly.find(params[:user_id])
        @user_education = @user.user_educations.find(params[:id])
        @user_education.destroy

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @user = User.friendly.find(params[:user_id])
        @user_education = @user.user_educations.find(params[:id])
    end

    private

    def user_education_param
        params.require(:user_education).permit(:id, :user_id, :start_date, :end_date, :cert_level, :cert_type, :school_level, :school_name, :school_location, :school_field, :enrolled)
    end
end
