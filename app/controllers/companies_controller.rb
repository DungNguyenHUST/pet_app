class CompaniesController < ApplicationController
    include ::CompaniesHelper
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true
			@company_searchs = Company.friendly.search(params[:search]).approved.order('name ASC').page(params[:page]).per(12)
		end
        @companies_all = Company.all.approved
        @companies_oder_name = Company.all.order('name ASC').approved.page(params[:page]).per(20)
        @companies_oder_newest = Company.all.order('created_at DESC').approved.page(params[:page]).per(20)
        # find most review company
        @companies_most_recent = @companies_all.sort_by{|company| company.company_reviews.count}.reverse
        # find best company
        @companies_best = @companies_all.sort_by{|company| cal_rating_review_total_score(company).to_f}.reverse

        @company_reviews = CompanyReview.all
        @company_interviews = CompanyInterview.all
        @company_jobs = CompanyJob.all.order('created_at DESC').approved
        @company_apply_jobs = CompanyApplyJob.all
        @company_reply_reviews = CompanyReplyReview.all
        @company_reply_interviews = CompanyReplyInterview.all
        
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
        @company_review = CompanyReview.new
        @company_interview = CompanyInterview.new
        @company_job = CompanyJob.new

        if current_user.admin?
            @company.approved = true
            @company.save!
            redirect_to root_path(tab_id: 'AdminCompanyID')
            return
        end

        if @company.save!
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
        @company_reviews = @company.company_reviews.order('created_at DESC').page(params[:page]).per(10)
        @company_interviews = @company.company_interviews.order('created_at DESC').page(params[:page]).per(10)
        @company_jobs = @company.company_jobs.order('created_at DESC').approved.page(params[:page]).per(10)
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
        if company_param.present? && !(company_param.has_key?(:approved))
			if(@company.update(company_param))
				if @company.approved?
					redirect_to company_path(@company)
				else
					flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên xử lý trong 30min - 1h"
					redirect_to companies_path
				end
			else
				flash[:error] = "Lỗi, không thể cập nhật thông tin vui lòng kiểm tra lại ..."
			end
        else
            if (!@company.approved? && @company.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to user_path(current_user, tab_id: 'AdminCompanyID')
            elsif (@company.approved? && @company.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to user_path(current_user, tab_id: 'AdminCompanyID')
            end
        end
    end

    def destroy
        @company = Company.friendly.find params[:id]
        @company.destroy
        redirect_to root_path(tab_id: 'AdminCompanyID')
    end

    private
    # define param for each company
    def company_param
        params.require(:company).permit(:name, :location, :address, :country, :website, :phone, :time_establish, :working_time, :working_date, :size, :field_operetion, :avatar, :wall_picture, :search, :overview, :policy, :values, :company_type, {:benefit => []})
    end
end
