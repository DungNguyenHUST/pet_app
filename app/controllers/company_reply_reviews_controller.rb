class CompanyReplyReviewsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]

    def index 
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_reply_reviews = @company_review.company_reply_reviews
    end

    def new
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_reply_review = CompanyReplyReview.new
    end

    def create
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_reply_review = @company_review.company_reply_reviews.build(company_reply_review_param)

        if user_signed_in?
            @company_reply_review.user_name = current_user.name
            @company_reply_review.user_id = current_user.id
        end

        if @company_reply_review.save
            if(find_owner_user(@company_review).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@company_review), 
                                                            current_user, 
                                                            @company_review.position, 
                                                            @company_reply_review.reply_content, 
                                                            company_path(@company, tab: 'CompanyReviewsID'), 
                                                            "ReviewComment")
            end
            
            # redirect_to company_path(@company, tab: 'CompanyReviewsID')
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = I18n.t(:create_error)
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_reply_review = @company_review.company_reply_reviews.find(params[:id])

        @company_reply_review.destroy
        redirect_to company_path(@company, tab: 'CompanyReviewsID')
    end

    def show
        @company_review = CompanyReview.find(params[:company_review_id])
        @company = @company_review.company
        @company_reply_review = @company_review.company_reply_reviews.find(params[:id])
    end

    private

    def company_reply_review_param
        params.require(:company_reply_review).permit(:reply_content)
    end
end
