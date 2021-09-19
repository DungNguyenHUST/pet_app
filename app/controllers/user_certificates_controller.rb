class UserCertificatesController < ApplicationController
    before_action :require_user_login, only: [:index, :show, :edit, :update, :destroy]

    def index 
        @users = User.all
        @user_certificates = UserSkill.all
    end

    def new
        @user = User.friendly.find(params[:user_id])
        @user_certificate = UserSkill.new
    end

    def create
        @user = User.friendly.find(params[:user_id])
        @user_certificate = @user.user_certificates.build(user_certificate_param)
        @user_certificate.save

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
        @user = User.friendly.find params[:user_id]
        @user_certificate = @user.user_certificates.find(params[:id])
    end

    def update
        @user = User.friendly.find params[:user_id]
        @user_certificate = @user.user_certificates.find(params[:id])
        @user_certificate.update(user_certificate_param)

        respond_to do |format|
            format.html {}
            format.js
        end
    end
    
    def destroy
        @user = User.friendly.find(params[:user_id])
        @user_certificate = @user.user_certificates.find(params[:id])
        @user_certificate.destroy

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @user = User.friendly.find(params[:user_id])
        @user_certificate = @user.user_certificates.find(params[:id])
    end

    private

    def user_certificate_param
        params.require(:user_certificate).permit(:id, :user_id, :cert_summary, :cert_name, :start_date, :end_date)
    end
end
