class CompanyDislikeReviewsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_reviews = @company.company_reviews
        @company_dislike_reviews = @company_reviews.company_dislike_reviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_dislike_review = CompanyDislikeReview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_review = CompanyReview.friendly.find(params[:company_review_id])
        
        if already_liked?
            # flash[:notice] = "You can't dislike more than once"
        else
            @company_dislike_review = @company_review.company_dislike_reviews.create(user_id: current_user.id)
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
        @company_dislike_review = @company_review.company_dislike_reviews.find(params[:id])

        @company_dislike_review.destroy
        respond_to do |format|
            format.html {}
            format.js
        end
        # redirect_to company_path(@company)
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_dislike_review = @company_review.company_dislike_reviews.find(params[:id])
    end

    private

    def company_dislike_review_param
        # params.require(:company_dislike_review).permit(:like_content)
    end

    def already_liked?
        CompanyDislikeReview.where(user_id: current_user.id, company_review_id: params[:company_review_id]).exists?
    end
end
