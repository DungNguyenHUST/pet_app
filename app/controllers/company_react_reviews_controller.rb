class CompanyReactReviewsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_review = CompanyReview.find(params[:company_review_id])
        @company_react_reviews = @company_review.company_react_reviews
    end

    def new
        @company_review = CompanyReview.find(params[:company_review_id])
        @company_react_review = CompanyReactReview.new
    end

    def create
        @company_review = CompanyReview.find(params[:company_review_id])

        @react = @company_review.company_react_reviews.find { |react| (react.user_id == current_user.id) && (react.react_type == 0 || react.react_type == 1)}

        unless @react.nil?
            @react.update(react_type: params[:react_type])
        else
            # Created reactd
            @company_react_review = @company_review.company_react_reviews.build(user_id: current_user.id, react_type: params[:react_type])
            @company_react_review.save!
        end

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
        @company_react_review = @company_review.company_react_reviews.find(params[:id])
        @company_react_review.destroy
        @type_param = params[:type_param]

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
    end

    private
end
