class CompanyLikeReviewsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_like_reviews = @company_review.company_like_reviews
    end

    def new
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_like_review = CompanyLikeReview.new
    end

    def create
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company

        if !already_liked?
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
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_like_review = @company_review.company_like_reviews.find(params[:id])
        @company_like_review.destroy
        
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_like_review = @company_review.company_like_reviews.find(params[:id])
    end

    private
    
    def already_liked?
        CompanyLikeReview.where(user_id: current_user.id, company_review_id: params[:company_review_id]).exists?
    end
end
