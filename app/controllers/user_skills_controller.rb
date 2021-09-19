class UserSkillsController < ApplicationController
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy]

    def index 
        @users = User.all
        @user_skills = UserSkill.all
    end

    def new
        @user = User.friendly.find(params[:user_id])
        @user_skill = UserSkill.new
    end

    def create
        @user = User.friendly.find(params[:user_id])
        @user_skill = @user.user_skills.build(user_skill_param)
        @user_skill.save

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
        @user = User.friendly.find params[:user_id]
        @user_skill = @user.user_skills.find(params[:id])
    end

    def update
        @user = User.friendly.find params[:user_id]
        @user_skill = @user.user_skills.find(params[:id])
        @user_skill.update(user_skill_param)

        respond_to do |format|
            format.html {}
            format.js
        end
    end
    
    def destroy
        @user = User.friendly.find(params[:user_id])
        @user_skill = @user.user_skills.find(params[:id])
        @user_skill.destroy

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @user = User.friendly.find(params[:user_id])
        @user_skill = @user.user_skills.find(params[:id])
    end

    private

    def user_skill_param
        params.require(:user_skill).permit(:id, :user_id, :skill_level, :skill_name, :skill_summary)
    end
end
