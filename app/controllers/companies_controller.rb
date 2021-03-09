class CompaniesController < ApplicationController
    def index
        @companies = Company.friendly.search(params[:search]).approved
        @companies_all = Company.all.approved
        @companies_oder_name = Company.all.order('name DESC').approved
        @companies_oder_newest = Company.all.order('created_at DESC').approved
        @companies_most_recent = Company.all.order('created_at DESC').approved.reverse
        @companies_best = []
        count = 0
        @companies_all.each do |company|
			if company.approved?
				if cal_company_score(company).to_f > count
					@companies_best.push(company)
					count = cal_company_score(company).to_f
				end
			end
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
			if @company.approved?
				redirect_to company_path(@company)
			else
				flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
				redirect_to companies_path
			end
        else
            flash[:danger] = "Lỗi, không thể lưu thông tin công ty"
            render :new
        end
    end

    def show
        @company = Company.friendly.find params[:id]
        @company_review = CompanyReview.new(company_id: params[:company_id])
        @company_reply_review = CompanyReplyReview.new(company_review_id: params[:company_review_id])
        @company_interview = CompanyInterview.new(company_id: params[:company_id])
        @company_reply_interview = CompanyReplyInterview.new(company_interview_id: params[:company_interview_id])
        @company_job = CompanyJob.new(company_id: params[:company_id])
        @company_apply_job = CompanyApplyJob.new(company_job_id: params[:company_job_id])

    end

    def edit
        @company = Company.friendly.find params[:id]
    end

    def update
        @company = Company.friendly.find params[:id]
		if @company.update_column(:approved, true)
			flash[:success] = "Approved"
			redirect_to pages_path
		else
			if(@company.update(company_param))
				if @company.approved?
					redirect_to company_path(@company)
				else
					flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên xử lý trong 30min - 1h"
					redirect_to companies_path
				end
			else
				flash[:error] = "Lỗi, không thể cập nhật thông tin"
			end
		end
    end

    def destroy
        @company = Company.friendly.find params[:id]
        @company.destroy
        redirect_to pages_path
    end

    private
    # define param for each company
    def company_param
        params.require(:company).permit(:name, :location, :address, :country, :website, :phone, :time_establish, :time_start, :time_end, :size, :field_operetion, :avatar, :wall_picture, :search, :overview_rich_text, :policy_rich_text, :values)
    end

    def cal_company_score(company)
        if(company.company_reviews.count > 0)
            rate_work_env = company.company_reviews.sum('work_env_score').to_f / company.company_reviews.count
            rate_salary = company.company_reviews.sum('salary_score').to_f / company.company_reviews.count
            rate_ot = company.company_reviews.sum('ot_score').to_f / company.company_reviews.count
            rate_manager = company.company_reviews.sum('manager_score').to_f / company.company_reviews.count
            rate_career = company.company_reviews.sum('career_score').to_f / company.company_reviews.count

            total_rate = (rate_work_env + rate_salary + rate_ot + rate_manager + rate_career)/5
        else
            total_rate = 0
        end
    end
end
