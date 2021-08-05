class CompaniesController < ApplicationController
    include ::CompaniesHelper
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]

    def index
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true
			@company_searchs = Company.friendly.search(params[:search]).order('name ASC').page(params[:page]).per(12)
		end

        @companies_all = Company.all
        @companies_oder_name = Company.all.order('name ASC').page(params[:page]).per(18)
        @companies_oder_newest = Company.all.order('created_at DESC').page(params[:page]).per(18)
        @companies_most_recent = @companies_all.sort_by{|company| company.company_reviews.count}.reverse
        @companies_best = @companies_all.sort_by{|company| cal_rating_review_total_score(company).to_f}.reverse
        
        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
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
			redirect_to company_path(@company)
        else
            flash[:danger] = "Lỗi, không thể lưu thông tin công ty"
            render :new
        end
    end

    def show
        @company = Company.friendly.find params[:id]
        @company_reviews = @company.company_reviews.order('created_at DESC').page(params[:page]).per(10)
        @company_interviews = @company.company_interviews.order('created_at DESC').page(params[:page]).per(10)
        @company_jobs = @company.company_jobs.order('created_at DESC').page(params[:page]).per(10)
        @company_questions = @company.company_questions.order('created_at DESC').page(params[:page]).per(10)
        @company_images = @company.company_images.order('created_at DESC').page(params[:page]).per(12)

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
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
