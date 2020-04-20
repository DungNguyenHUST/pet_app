class CompaniesController < ApplicationController
    def index
        @companies = Company.all
        @company_reviews = CompanyReview.all
        @company_interviews = CompanyInterview.all
        @company_reply_reviews = CompanyReplyReview.all
        @company_reply_interviews = CompanyReplyInterview.all
    end

    def new
        @company = Company.new
    end

    def create
        @company = Company.new(company_param)
        @company_review = CompanyReview.new
        @company_interview = CompanyInterview.new

        if @company.save
            redirect_to companies_path
        else
            flash[:danger] = "Hãy lưu lại thông tin của công ty"
            # render :new
        end
    end

    def show
        @company = Company.find params[:id]
        @company_review = CompanyReview.new(company_id: params[:company_id])
        @company_reply_review = CompanyReplyReview.new(company_review_id: params[:company_review_id])
        @company_interview = CompanyInterview.new(company_id: params[:company_id])
        @company_reply_interview = CompanyReplyInterview.new(company_interview_id: params[:company_interview_id])
    end

    def edit
        @company = Company.find params[:id]
    end

    def update
        @company = Company.find params[:id]
    end

    def destroy
        @company = Company.find params[:id]
        @company.destroy
        redirect_to company_path
    end

    private
    # define param for each company
    def company_param
        params.require(:company).permit(:name, :image, :location, :website, :size , :overview)
    end
end
