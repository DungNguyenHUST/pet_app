class CompanyReplyReviewsController < ApplicationController
    include ApplicationHelper
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_reviews = @company.company_reviews
        @company_reply_reviews = @company_reviews.company_reply_reviews
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = CompanyReplyReview.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.build(company_reply_review_param)
        @company_reply_review.user_name = current_user.name
        @company_reply_review.user_id = current_user.id

        if @company_reply_review.save
            if(find_owner_user(@company_review).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@company_review), current_user, @company_review.position, @company_reply_review.reply_content, company_path(@company, tab_id: 'CompanyReviewsID'), "ReviewComment")
            end
            # redirect_to company_path(@company, tab_id: 'CompanyReviewsID')
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.find(params[:id])

        @company_reply_review.destroy
        redirect_to company_path(@company, tab_id: 'CompanyReviewsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:company_review_id])
        @company_reply_review = @company_review.company_reply_reviews.find(params[:id])
    end

    private

    def company_reply_review_param
        params.require(:company_reply_review).permit(:reply_content)
    end
end
