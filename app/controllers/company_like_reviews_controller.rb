class CompanyLikeReviewsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    before_action :find_company_review
    before_action :find_like, only: [:destroy]
    
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_reviews = @company.company_reviews
        @company_like_reviews = @company_reviews.company_like_reviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_like_review = CompanyLikeReview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_review = CompanyReview.friendly.find(params[:company_review_id])
        if already_liked?
            # flash[:notice] = "You can't like more than once"
        else
            @company_like_review = @company_review.company_like_reviews.create(user_id: current_user.id)
        end
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_like_review = @company_review.company_like_reviews.find(params[:id])
        @company_like_review.destroy
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_like_review = @company_review.company_like_reviews.find(params[:id])
    end

    private

    def company_like_review_param
        # params.require(:company_like_review).permit(:like_content)
    end

    def already_liked?
        CompanyLikeReview.where(user_id: current_user.id, company_review_id: params[:company_review_id]).exists?
    end

    def find_company_review
        @company_review = CompanyReview.friendly.find(params[:company_review_id])
    end

    def find_like
        @like = @company_review.company_like_reviews.find(params[:id])
    end
end
