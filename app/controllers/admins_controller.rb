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

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        @admins = Admin.all
        @users = User.all.order('created_at DESC').page(params[:page]).per(25)
        @companies = Company.all.page(params[:page]).order('created_at DESC').per(25)
        @company_jobs = CompanyJob.all.page(params[:page]).order('created_at DESC').per(25)
        @company_jobs_approving = CompanyJob.all.approving.page(params[:page]).order('created_at DESC').per(25)
        @company_reviews = CompanyReview.all.page(params[:page]).order('created_at DESC').per(25)
        @posts = Post.all.order('created_at DESC').page(params[:page]).per(25)
        @problems = Problem.all.order('created_at DESC').page(params[:page]).per(25)
        @problems_approving = Problem.all.approving.page(params[:page]).order('created_at DESC').per(25)
        @employers = Employer.all.order('created_at DESC').page(params[:page]).per(25)
        @employer_bills = EmployerBill.all.order('created_at DESC').page(params[:page]).per(25)
        @employer_bills_confirming = EmployerBill.all.confirming.order('created_at DESC').page(params[:page]).per(25)
        @scrap_jobs = ScrapJob.all.approved.order('created_at DESC').page(params[:page]).per(25)
        @scrap_reviews = ScrapReview.all.approved.order('created_at DESC').page(params[:page]).per(25)
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
