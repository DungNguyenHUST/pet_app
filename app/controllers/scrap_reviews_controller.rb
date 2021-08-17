class ScrapReviewsController < ApplicationController
    before_action :require_admin_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index
        @scrap_reviews = ScrapReview.all
    end

    def new
        @scrap_review = ScrapReview.new
    end

    def create
        @scrap_review = ScrapReview.new(scrap_review_param)
        if @scrap_review.save
            ScraperReviewJob.perform_now(@scrap_review)
            flash[:success] = "Scrap review successed ..............."
            redirect_to admin_path(current_admin, tab_id: 'ScrapReviewID')
        end
    end

    def scrap_review_param
        params.require(:scrap_review).permit(:id, :company_id, :company_name, :url, :raw_data)
    end
end
