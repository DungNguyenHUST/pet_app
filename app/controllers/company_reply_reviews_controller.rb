class CompanyReplyReviewsController < ApplicationController
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_reviews = @company.company_reviews
        @company_reply_reviews = @company_reviews.company_reply_reviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_reply_review = CompanyReplyReview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.build(company_reply_review_param)

        if logged_in?
            @company_reply_review.user_name = @current_user.name
        else
            @company_reply_review.user_name = "Ẩn danh"
        end

        if @company_reply_review.save
            redirect_to company_path(@company, tab_id: 'CompanyReviewsID')
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            # render :new
        end
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.friendly.find(params[:id])

        @company_reply_review.destroy
        redirect_to company_path(@company, tab_id: 'CompanyReviewsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.friendly.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.friendly.find(params[:id])
    end

    private

    def company_reply_review_param
        params.require(:company_reply_review).permit(:reply_content)
    end
end
