class AdminsController < ApplicationController
    include AdminsHelper
    include ApplicationHelper
    before_action :require_admin_login, only: [:index, :show, :edit, :update, :destroy]
    
    def index
        @admins = Admin.all
    end

    def new
        @admin = Admin.new
    end
    
    def create
        @admin = Admin.new(admin_params)
    end

    def show
        @admin = current_admin

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end

        @admins = Admin.all
        @users = User.all.page(params[:page]).per(20)
        @companies = Company.all.page(params[:page]).per(20)
        @company_jobs = CompanyJob.all.page(params[:page]).per(20)
        @company_reviews = CompanyReview.all.page(params[:page]).per(20)
        @posts = Post.all.page(params[:page]).per(20)
        @problems = Problem.all.page(params[:page]).per(20)
    end

    def edit
        @admin = Admin.friendly.find params[:id]
    end

    def destroy
        @admin = Admin.friendly.find params[:id]
        @admin.destroy
        redirect_to admin_path(current_admin)
    end

    def update
        @admin = Admin.friendly.find params[:id]
    end
    
    private

    def admin_params
        params.require(:admin).permit :name, :email, :password, :password_confirmation
    end
end
