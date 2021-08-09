class CompanyJobsController < ApplicationController
    include ApplicationHelper
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]

    def index 
        @companies = Company.all
        @company_jobs = CompanyJob.all
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_job = CompanyJob.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.build(company_job_param)
        
        if employer_signed_in?
            @company_job.user_id = current_employer.id
        end

        @company_job.title_converted = convert_vie_to_eng(@company_job.title)
        @company_job.location_converted = convert_vie_to_eng(@company_job.location)

        if @company_job.save
			redirect_to company_company_job_path(@company, @company_job)
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu "
            render :new
        end
    end

    def edit
        @is_edit = params[:is_edit]
        @company = Company.friendly.find params[:company_id]
        @company_job = @company.company_jobs.friendly.find(params[:id])
    end

    def update
        @company = Company.friendly.find params[:company_id]
        @company_job = @company.company_jobs.friendly.find(params[:id])

        if(@company_job.update(company_job_param))
            flash[:success] = "Update thông tin thành công"
            redirect_to company_job_path(@company_job)
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:id])
        @company_job.destroy
        redirect_to company_path(@company, tab_id: 'CompanyJobsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_job = @company.company_jobs.friendly.find(params[:id])

        @company_jobs = @company.company_jobs.order('created_at DESC')
        @company_jobs = @company_jobs.reject{|i| i.id == @company_job.id}
        @company_related_jobs = Kaminari.paginate_array(@company_jobs).page(params[:page]).per(10)
    end
	
	def list
        @companies = Company.all
		@company_jobs = CompanyJob.all.order('created_at DESC').page(params[:page]).per(10)
    end

    def search
        @company_jobs = CompanyJob.all.order('created_at DESC').page(params[:page]).per(10)

        # Search
		if(params.has_key?(:search) && params.has_key?(:location))
			@search = convert_vie_to_eng(params[:search])
			@location = convert_vie_to_eng(params[:location])
            if @location.to_s == "tat ca dia diem"
                @job_searchs = CompanyJob.friendly.search(@search).order('created_at DESC').page(params[:page]).per(12)
            else
			    @job_searchs = CompanyJob.friendly.search_advance(@search, @location).order('created_at DESC').page(params[:page]).per(12)
            end
        end

        # Filter
        if params.has_key?(:filter)
            @category = filter_params[:category]
            @salary = filter_params[:salary]
            @level = filter_params[:level]
            @post_date = filter_params[:post_date]
            @job_type = filter_params[:job_type]
            @search = filter_params[:search]
            @location = filter_params[:location]
            @filter_params_converted = filter_params_converted.new(@category, @salary, @level, @post_date, @job_type, @search, @location)

            @job_filtereds = CompanyJob.friendly.filtered(@filter_params_converted ).order('created_at DESC').page(params[:page]).per(12)
            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :benefit, :requirement, :salary, :quantity, :category, :search, :end_date, :language, :level, :job_type, :urgent, :apply_another_site_flag, :apply_site, :address, {:skill => []})
    end

    def filter_params
        filter_params = params.require(:filter).permit(:category, :salary, :level, :post_date, :job_type, :search, :location)
    end

    def filter_params_converted
        filter_params_converted = Struct.new(:category,
                                            :salary,
                                            :level, 
                                            :post_date,
                                            :job_type,
                                            :search,
                                            :location)
    end
end
