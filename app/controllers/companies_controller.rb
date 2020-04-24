class CompaniesController < ApplicationController
    helper_method :rating_total_score
    helper_method :rating_work_env_score
    helper_method :rating_salary_score
    helper_method :rating_ot_score
    helper_method :rating_manager_score
    helper_method :rating_career_score

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

    def rating_total_score
        rate_work_env = @company.company_reviews.sum('work_env_score') / @company.company_reviews.count
        rate_salary = @company.company_reviews.sum('salary_score') / @company.company_reviews.count
        rate_ot = @company.company_reviews.sum('ot_score') / @company.company_reviews.count
        rate_manager = @company.company_reviews.sum('manager_score') / @company.company_reviews.count
        rate_career = @company.company_reviews.sum('career_score') / @company.company_reviews.count

        total_rate = (rate_work_env + rate_salary + rate_ot + rate_manager + rate_career).to_f/5
    end

    def rating_work_env_score
        rate_work_env = @company.company_reviews.sum('work_env_score').to_f / @company.company_reviews.count
    end

    def rating_salary_score
        rate_salary = @company.company_reviews.sum('salary_score').to_f / @company.company_reviews.count
    end

    def rating_ot_score
        rate_ot = @company.company_reviews.sum('ot_score').to_f / @company.company_reviews.count
    end

    def rating_manager_score
        rate_manager = @company.company_reviews.sum('manager_score').to_f / @company.company_reviews.count
    end

    def rating_career_score
        rate_career = @company.company_reviews.sum('career_score').to_f / @company.company_reviews.count
    end

    private
    # define param for each company
    def company_param
        params.require(:company).permit(:name, :location, :country, :website, :time_establish, :time_start, :time_end, :size, :field_operetion, :content, :policy, :avatar)
    end
end
