class CompaniesController < ApplicationController
    include CompaniesHelper
    include ApplicationHelper
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]

    def index
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true
            @search = convert_vie_to_eng(params[:search])
			@company_searchs = Company.friendly.search(@search).order('name ASC').page(params[:page]).per(12)
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

        @company.name_converted = convert_vie_to_eng(@company.name)
        @company.location_converted = convert_vie_to_eng(@company.location)

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
