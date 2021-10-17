class CompanyJobsController < ApplicationController
    include ApplicationHelper
    include CompanyJobsHelper
    include CompaniesHelper
    include EmployersHelper
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]

    def index
        @company_jobs = CompanyJob.all.expire
    end

    def new
        @company_job = CompanyJob.new
        if employer_signed_in?
            @company = find_company_of_employer(current_employer)
        end
    end

    def create
        @company_job = CompanyJob.new(company_job_param)
        
        if employer_signed_in?
            @company_job.employer_id = current_employer.id
            @employer_company = find_company_of_employer(current_employer)
            @company_job.company_id = @employer_company.id
            @company_job.company_name = @employer_company.name
            if auth_sponsor_plan_of_employer(current_employer)
                @company_job.sponsor = true
            end

            if @company_job.save
                redirect_to employer_index_job_path
                flash[:success] = "Để đảm bảo chất lượng thông tin, tin đăng của bạn đang được xếp vào hàng chờ để duyệt thông tin. Xin vui lòng kiểm tra kết quả sau ít phút..."
            else
                flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu *"
                render :new
            end
        elsif admin_signed_in?
            @company_job.approved = true

            if @company_job.save
                redirect_to company_job_path(@company_job)
            else
                flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu *"
                render :new
            end
        else
            flash[:danger] = "Error, no permission for this action"
        end
    end

    def edit
        @is_edit = params[:is_edit]
        @company_job = CompanyJob.friendly.find(params[:id])
        @company = find_company_of_job(@company_job)
    end

    def update
        @company_job = CompanyJob.friendly.find(params[:id])

        if(@company_job.update(company_job_param))
            flash[:success] = "Update thông tin thành công"
            redirect_to company_job_path(@company_job)
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end
    end
    
    def destroy
        @company_job = CompanyJob.friendly.find(params[:id])
        @company_job.destroy
        redirect_to company_path(@company, tab: 'CompanyJobsID')
    end

    def show
        @company_job = CompanyJob.friendly.find(params[:id])
        @company = find_company_of_job(@company_job)
        @company_job.increment!(:view_count)
        if @company.present?
            if find_job_of_company(@company)
                @company_jobs = find_job_of_company(@company)
            else
                @company_jobs = find_same_job(@company_job)
            end
            
            if @company_jobs
                @company_jobs = @company_jobs.reject{|i| i.id == @company_job.id}
                @company_related_jobs = Kaminari.paginate_array(@company_jobs).page(params[:page]).per(10)
            end
        end

        # for preview mode
        respond_to do |format|
            format.html {}
            format.js
        end
    end
	
	def list
		@company_jobs = CompanyJob.all.order('created_at DESC').expire.page(params[:page]).per(20)
    end

    def search
        @company_jobs    = CompanyJob.search_job_by_query(params[:search])
        respond_to do |format|
            format.html {}
            format.json {
                @company_jobs    = @company_jobs.limit(10)
            }
        end

        @job_recommands = CompanyJob.all.order('created_at DESC').expire.page(params[:page]).per(20)

        # Search
        @is_search = false
		if(params.has_key?(:search) && params.has_key?(:location))
            @is_search = true
            @job_searchs = CompanyJob.all

            unless params[:search].empty?
                @job_searchs = @job_searchs.search_job_by_query(params[:search])
            end

            unless params[:location].empty?
                @job_searchs = @job_searchs.search_job_by_location(params[:location])
            end
            
            @job_searchs = @job_searchs.order('created_at DESC').expire.page(params[:page]).per(20)
        end

        # Filter
        @is_filter = false
        if params.has_key?(:filter)
            @is_filter = true
            @is_search = true
            @job_filtereds = CompanyJob.all

            @search = nil
            @location = nil
            @category = nil
            @salary_min = nil
            @salary_max = nil
            @level = nil
            @post_date = nil
            @typical = nil
            
            if filter_params[:search].present?
                @search = filter_params[:search]
            end

            if filter_params[:location].present?
                @location = filter_params[:location]
            end

            if filter_params[:category].present?
                @category = filter_params[:category]
            end

            if filter_params[:salary].present?
                @salary_min = convert_salary_to_min(filter_params[:salary])
                @salary_max = convert_salary_to_max(filter_params[:salary])
            end

            if filter_params[:level].present?
                @level = filter_params[:level]
            end

            if filter_params[:post_date].present?
                @post_date = filter_params[:post_date].scan(/\d+/).map(&:to_i).first
            end

            if filter_params[:typical].present?
                @typical = filter_params[:typical]
            end

            @filter_params_input = filter_params_input.new(@category, @salary_min, @salary_max, @level, 
                                                                    @post_date, @typical, @search, @location)

            @job_filtereds = CompanyJob.friendly.filtered(@filter_params_input ).order('created_at DESC').expire.page(params[:page]).per(20)

            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :benefit, 
                                            :requirement, :salary, :quantity, :category, 
                                            :search, :end_date, :language, :level, :typical, 
                                            :urgent, :apply_another_site_flag, :apply_site, 
                                            :address, :experience, :policy, {:skill => []})
    end

    def filter_params
        filter_params = params.require(:filter).permit(:category, :salary, :level, :post_date, :typical, :search, :location)
    end

    def filter_params_input
        filter_params_input = Struct.new(:category,
                                            :salary_min,
                                            :salary_max,
                                            :level, 
                                            :post_date,
                                            :typical,
                                            :search,
                                            :location)
    end
end
