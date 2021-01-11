class CompaniesController < ApplicationController
    def index
        @companies = Company.search(params[:search])
        @companies_all = Company.all
        @companies_oder_name = Company.search(params[:search]).order('name DESC')
        @companies_oder_newest = Company.all.order('created_at DESC')
        @companies_most_recent = Company.all.order('created_at DESC').reverse
        @companies_best = []
        @companies.each do |company|
            @companies_best.push(company)
        end
        @company_reviews = CompanyReview.all
        @company_interviews = CompanyInterview.all
        @company_jobs = CompanyJob.all
        @company_apply_jobs = CompanyApplyJob.all
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
        @company_job = CompanyJob.new

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
        @company_job = CompanyJob.new(company_id: params[:company_id])
        @company_apply_job = CompanyApplyJob.new(company_job_id: params[:company_job_id])

    end

    def edit
        @company = Company.find params[:id]
    end

    def update
        @company = Company.find params[:id]
        if(@company.update(company_param))
            redirect_to companies_path
        else
            flash[:danger] = "Không thể cập nhật thông tin"
        end
    end

    def destroy
        @company = Company.find params[:id]
        @company.destroy
        redirect_to pages_path
    end

    private
    # define param for each company
    def company_param
        params.require(:company).permit(:name, :location, :address, :country, :website, :phone, :time_establish, :time_start, :time_end, :size, :field_operetion, :avatar, :wall_picture, :search, :overview_rich_text, :policy_rich_text)
    end
end
