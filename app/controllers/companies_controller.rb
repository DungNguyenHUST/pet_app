class CompaniesController < ApplicationController
    include CompaniesHelper
    include ApplicationHelper
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]

    add_breadcrumb "Trang chủ", :root_path

    def index
        add_breadcrumb "Danh sách công ty", :companies_path
        
        # Auto complete
        @suggest_companies = Company.search_company_by_name(params[:search])
        respond_to do |format|
            format.html {}
            format.json {
                @suggest_companies = @suggest_companies.limit(10)
            }
        end

        # Search
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true
			@company_searchs = Company.search_company_by_name(params[:search]).order('name ASC').page(params[:page]).per(12)
		end
        
        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        @companies_all = Company.all
        
        @companies_oder_name = Company.all.order('name ASC').page(params[:page]).per(18)

        if @tab == "CompanyNewestID"
            @companies_oder_newest = Company.all.order('created_at DESC').page(params[:page]).per(18)
        end

        if @tab == "CompanyMostRecentID"
            @companies_most_recent = Company.all.sort_by{|company| company.company_reviews.count}.reverse
            @companies_most_recent = Kaminari.paginate_array(@companies_most_recent).page(params[:page]).per(18)
        end

        if @tab == "CompanyBestID"
            @companies_best = Company.all.sort_by{|company| cal_rating_review_total_score(company).to_f}.reverse
            @companies_best = Kaminari.paginate_array(@companies_best).page(params[:page]).per(18)
        end
    end

    def new
        @company = Company.new
    end

    def create
        @company = Company.new(company_param)
        if employer_signed_in?
            @company.employer_id = current_employer.id
        end

        if @company.save!
            if employer_signed_in?
                redirect_to employer_path(current_employer, tab: 'EmployerCompanyID')
            else
                redirect_to company_path(@company)
            end
        else
            flash[:danger] = "Lỗi, không thể lưu thông tin công ty"
            render :new
        end
    end

    def show
        @company = Company.friendly.find params[:id]
        @company_reviews = @company.company_reviews.order('created_at DESC').page(params[:page]).per(10)
        @company_interviews = @company.company_interviews.order('created_at DESC').page(params[:page]).per(10)
        @company_jobs = find_job_of_company(@company).order('created_at DESC').page(params[:page]).per(10)
        @company_questions = @company.company_questions.order('created_at DESC').page(params[:page]).per(10)
        @company_images = @company.company_images.order('created_at DESC').page(params[:page]).per(12)

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        add_breadcrumb "Danh sách công ty", :companies_path
        add_breadcrumb @company.name, company_path(@company)
        if @tab == "CompanyProfileID"
            add_breadcrumb "Tổng quan chung", company_path(@company)                        
        elsif @tab == "CompanyPolicyID"
            add_breadcrumb "Chính sách", company_path(@company) 
        elsif  @tab == "CompanyReviewsID"
            add_breadcrumb "Review", company_path(@company)
        elsif  @tab == "CompanyInterviewsID"
            add_breadcrumb "Phỏng vấn", company_path(@company)
        elsif @tab == "CompanyJobsID"
            add_breadcrumb "Việc làm", company_path(@company)
        elsif @tab == "CompanySalariesID"
            add_breadcrumb "Lương", company_path(@company)
        elsif  @tab == "CompanyQuestionsID"
            add_breadcrumb "Câu hỏi", company_path(@company) 
        elsif  @tab == "CompanyImagesID"
            add_breadcrumb "Hình ảnh", company_path(@company)
        end
    end

    def edit
        @is_edit = params[:is_edit]
        @company = Company.friendly.find params[:id]
    end

    def update
        @company = Company.friendly.find params[:id]
        if(@company.update(company_param))
            flash[:danger] = "Cập nhật thông tin thành công"
            redirect_to company_path(@company)
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end
    end

    def destroy
        @company = Company.friendly.find params[:id]
        @company.destroy
        redirect_to companies_path
    end

    private
    def company_param
        params.require(:company).permit(:name, :location, :address, :country, :website, :phone, :time_establish, :working_time, :working_date, :size, :field_operetion, :avatar, :wall_picture, :search, :overview, :policy, :values, :company_type, :employer_id, {:benefit => []})
    end
end
