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

            @company_job = convert_job_param(@company_job)

            if @company_job.save
                redirect_to employer_index_job_path
                flash[:success] = "Để đảm bảo chất lượng thông tin, chúng tôi đang tiến hành xử lý để duyệt tin đăng của bạn, xin vui lòng chờ sau ít phút..."
            else
                flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu *"
                render :new
            end
        else
            @company_job = convert_job_param(@company_job)

            if @company_job.save
                redirect_to company_job_path(@company_job)
            else
                flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu *"
                render :new
            end
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
        redirect_to company_path(@company, tab_id: 'CompanyJobsID')
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
        @is_search_not_found = false
        @is_search = false
        @job_searchs = CompanyJob.all.order('created_at DESC').expire.page(params[:page]).per(20)

        # Search
		if(params.has_key?(:search) && params.has_key?(:location))
			@search = convert_vie_to_eng(params[:search])
			@location = convert_vie_to_eng(params[:location])
            @job_searchs = CompanyJob.friendly.search(@search, @location).order('created_at DESC').expire.page(params[:page]).per(20)
            @is_search = true
            if @job_searchs.total_count == 0 
                @is_search_not_found = true
                @job_searchs = CompanyJob.all.order('created_at DESC').expire.page(params[:page]).per(20)
            end
        else
            @job_searchs = CompanyJob.all.order('created_at DESC').expire.page(params[:page]).per(20)
            @is_search = false
        end

        # Filter
        if params.has_key?(:filter)
            @category = nil
            @salary_min = nil
            @salary_max = nil
            @level = nil
            @post_date = nil
            @typical = nil
            @is_search = true

            if filter_params[:category].present?
                @category = convert_vie_to_eng(filter_params[:category])
            end

            if filter_params[:salary].present?
                @salary_min = convert_salary_to_min(filter_params[:salary])
                @salary_max = convert_salary_to_max(filter_params[:salary])
            end

            if filter_params[:level].present?
                @level = convert_vie_to_eng(filter_params[:level])
            end

            if filter_params[:post_date].present?
                @post_date = convert_vie_to_eng(filter_params[:post_date]).scan(/\d+/).map(&:to_i).first
            end

            if filter_params[:typical].present?
                @typical = convert_vie_to_eng(filter_params[:typical])
            end

            @search = convert_vie_to_eng(filter_params[:search])
            @location = convert_vie_to_eng(filter_params[:location])
            @filter_params_converted = filter_params_converted.new(@category, @salary_min, @salary_max, @level, 
                                                                    @post_date, @typical, @search, @location)

            @job_filtereds = CompanyJob.friendly.filtered(@filter_params_converted ).order('created_at DESC').expire.page(params[:page]).per(20)
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

    def filter_params_converted
        filter_params_converted = Struct.new(:category,
                                            :salary_min,
                                            :salary_max,
                                            :level, 
                                            :post_date,
                                            :typical,
                                            :search,
                                            :location)
    end
end
