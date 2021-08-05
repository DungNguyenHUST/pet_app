class CompanyReviewsController < ApplicationController
    before_action :require_user_login, only: [:edit, :update, :destroy]

    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_reviews = @company.company_reviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_review = CompanyReview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.build(company_review_param)

        if user_signed_in?
            @company_review.user_name = current_user.name
            @company_review.user_id = current_user.id
        end

        if @company_review.save
            redirect_to company_path(@company, tab_id: 'CompanyReviewsID')
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*' "
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:id])
        @company_review.destroy
        
        redirect_to company_path(@company, tab_id: 'CompanyReviewsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:id])
    end

    private

    def company_review_param
        params.require(:company_review).permit(:working_status, :working_time, :position, :work_env_score, :salary_score, :ot_score, :manager_score, :career_score, :score, :pros, :cons, :review_title, :review, :privacy, :recommend)
    end
end
