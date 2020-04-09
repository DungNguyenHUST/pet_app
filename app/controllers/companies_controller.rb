class CompaniesController < ApplicationController
    def index
        @companies = Company.all
        @company_reviews = CompanyReview.all
    end

    def new
        @company = Company.new
    end

    def create
        @company = Company.new(company_param)
        @company_review = CompanyReview.new

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
