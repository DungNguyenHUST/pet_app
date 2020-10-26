class CompanyDislikeReviewsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_reviews = @company.company_reviews
        @company_dislike_reviews = @company_reviews.company_dislike_reviews
    end

    def new
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_dislike_review = CompanyDislikeReview.new
    end

    def create
        @company = Company.find(params[:company_id])
        @company_review = CompanyReview.find(params[:company_review_id])
        if logged_in?
            @company_dislike_review = @company_review.company_dislike_reviews.create(user_id: current_user.id)

            if @company_dislike_review.save
                redirect_to company_path(@company)
            else
                flash[:danger] = "Lỗi, Không thể trả lời *?"
                # render :new
            end
        else
            redirect_to login_path
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_dislike_review = @company_review.company_dislike_reviews.find(params[:id])

        @company_dislike_review.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_dislike_review = @company_review.company_dislike_reviews.find(params[:id])
    end

    private

    def company_dislike_review_param
        # params.require(:company_dislike_review).permit(:like_content)
    end
end
