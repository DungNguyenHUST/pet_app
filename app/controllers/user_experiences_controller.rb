class UserExperiencesController < ApplicationController
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy]

    def index 
        @users = User.all
        @user_experiences = UserExperience.all
    end

    def new
        @user = User.friendly.find(params[:user_id])
        @user_experience = UserExperience.new
    end

    def create
        @user = User.friendly.find(params[:user_id])
        @user_experience = @user.user_experiences.build(user_experience_param)
        @user_experience.save

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
        @user = User.friendly.find params[:user_id]
        @user_experience = @user.user_experiences.find(params[:id])
    end

    def update
        @user = User.friendly.find params[:user_id]
        @user_experience = @user.user_experiences.find(params[:id])
        @user_experience.update(user_experience_param)

        respond_to do |format|
            format.html {}
            format.js
        end
    end
    
    def destroy
        @user = User.friendly.find(params[:user_id])
        @user_experience = @user.user_experiences.find(params[:id])
        @user_experience.destroy

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @user = User.friendly.find(params[:user_id])
        @user_experience = @user.user_experiences.find(params[:id])
    end

    private

    def user_experience_param
        params.require(:user_experience).permit(:id, :user_id, :start_date, :end_date, :company_name, :company_location, :job_level, :job_summary, :enrolled)
    end
end
