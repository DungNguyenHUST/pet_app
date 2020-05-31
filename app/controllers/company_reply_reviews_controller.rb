class CompanyReplyReviewsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_reviews = @company.company_reviews
        @company_reply_reviews = @company_reviews.company_reply_reviews
    end

    def new
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = CompanyReplyReview.new
    end

    def create
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.build(company_reply_review_param)

        @company_reply_review.user_name = @current_user.name

        if @company_reply_review.save
            redirect_to company_path(@company)
        else
            flash[:danger] = "Lỗi, Không thể trả lời *?"
            # render :new
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.find(params[:id])

        @company_reply_review.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.find(params[:id])
    end

    private

    def company_reply_review_param
        params.require(:company_reply_review).permit(:reply_content)
    end
end
