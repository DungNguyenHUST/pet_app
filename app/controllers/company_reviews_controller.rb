class CompanyReviewsController < ApplicationController
    def index 
        @company = Company.find(params[:company_id])
        @company_reviews = @company.company_reviews
    end

    def new
        @company_review = CompanyReview.new
    end

    def create
        @company = Company.find(params[:company_id])

        @company_review = @company.company_reviews.build(company_review_param)

        @company_review.user_name = @current_user.name

        @company_review.companyName = @company.name

        if @company_review.save
            flash[:success] = "Đã lưu lại nhận xét"
            redirect_to company_company_reviews_path(@company)
        else
            flash[:danger] = "Comment lỗi?"
            # render :new
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:id])
        @company_review.destroy
        redirect_to company_path(@company)
    end

    def show
        @company = Company.find(params[:company_id])
        @company_review = @company.company_reviews.find(params[:id])
    end

    private

    def company_review_param
        params.require(:company_review).permit(:companyName, :score , :review)
    end
end
