class CompanyJobsController < ApplicationController
    include ApplicationHelper
    include CompanyJobsHelper
    include CompaniesHelper
    include EmployersHelper
    include Constants
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]
    before_action :require_admin_login, only: [:approve]

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

            if @company_job.save
                redirect_to employer_mng_job_path
                flash[:success] = I18n.t(:job_create_noti)
            else
                flash[:danger] = I18n.t(:create_error)
                render :new
            end
        elsif admin_signed_in?
            @company_job.approved = true

            if @company_job.save
                redirect_to company_job_path(@company_job)
            else
                flash[:danger] = I18n.t(:create_error)
                render :new
            end
        else
            flash[:danger] = I18n.t(:error_no_permit)
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
            flash[:success] = I18n.t(:update_success)
            redirect_to company_job_path(@company_job)
        else
            flash[:danger] = I18n.t(:update_error)
        end
    end

    def approve
        @company_job = CompanyJob.friendly.find(params[:id])
        if @company_job.update(:approved => true)
            flash[:success] = I18n.t(:approve_success)
        else
            flash[:danger] = I18n.t(:approve_error)
        end
        redirect_to admin_path(current_admin, tab: 'AdminJobApprovingID')
    end
    
    def destroy
        @company_job = CompanyJob.friendly.find(params[:id])
        @company_job.destroy
        if employer_signed_in?
            redirect_to employer_mng_job_path
        else
            redirect_to admin_path(current_admin, tab: 'AdminJobID')
        end
    end

    def show
        @company_job = CompanyJob.friendly.find(params[:id])
        @company = find_company_of_job(@company_job)
        @company_job.increment!(:view_count)

        # Update employer cost in each view
        update_cost_for_view_job_of_employer(@company_job)
        
        add_breadcrumb I18n.t(:home_page), :root_path
        add_breadcrumb I18n.t(:job_search), :jobs_search_path
        add_breadcrumb @company_job.title, company_job_path(@company_job)
        
        if verified_job(@company_job)
            if find_job_of_company(@company)
                @company_jobs = find_job_of_company(@company)
            end
            
            if @company_jobs
                @company_jobs = @company_jobs.reject{|i| verified_job(i) == false}
                @company_jobs = @company_jobs.reject{|i| i.id == @company_job.id}
                @company_related_jobs = Kaminari.paginate_array(@company_jobs).page(params[:page]).per(15)
            end
        end

        @company_job_recommands = CompanyJob.all.order('created_at DESC').expire.limit(15)

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
        
        add_breadcrumb I18n.t(:home_page), :root_path
        add_breadcrumb I18n.t(:job_search), :jobs_search_path
        
        # Auto complete
        if params.has_key?(:search) && !params.has_key?(:filter)
            @suggest_jobs = CompanyJob.search(params[:search], 
                                                fields: ["title", "company_name", "category", "skill"], 
                                                where: {
                                                    end_date: {gt: Time.now}
                                                },
                                                order: {updated_at: :desc},
                                                page: params[:page], per_page: 20)
            respond_to do |format|
                format.html {}
                format.json {
                    @suggest_jobs = @suggest_jobs.limit(10)
                }
            end
        end

        # Search
        @job_recommands = CompanyJob.all.order('created_at DESC').expire.page(params[:page]).per(20)

        @is_search = false
        @is_filter = false

        st_selected = Struct.new(:category, :salary, :level, :post_date, :typical, :search, :location) 
        @selected_param = st_selected.new()                       

        if params.has_key?(:filter) # For Filter
            @is_filter = true

            @selected_param = st_selected.new(filter_params[:category], filter_params[:salary], filter_params[:level], filter_params[:post_date], 
                                            filter_params[:typical], filter_params[:search], filter_params[:location])

            query                   = filter_params[:search].presence || "*"
            args                    = {}
            args                    = args.merge(end_date: {gte: Time.now})
            args[:location]         = Array(filter_params[:location]) if filter_params[:location].present?
            args[:category]         = Array(filter_params[:category]) if filter_params[:category].present?
            args[:level]            = Array(filter_params[:level]) if filter_params[:level].present?
            args[:typical]          = Array(filter_params[:typical]) if filter_params[:typical].present?
            args                    = args.merge(salary_min: {gte: convert_salary_to_min(filter_params[:salary]).to_i}, salary_max: {lte: convert_salary_to_max(filter_params[:salary]).to_i}) if filter_params[:salary].present?
            args                    = args.merge(created_at: {gte: (Time.now - filter_params[:post_date].scan(/\d+/).map(&:to_i).first.days)}) if filter_params[:post_date].present?

            @job_filtereds = CompanyJob.search(query, 
                                            fields: ["title", "company_name", "category", "skill"], 
                                            where: args,
                                            order: {created_at: :desc},
                                            page: params[:page], per_page: 20)
                                            
        elsif(params.has_key?(:search) || params.has_key?(:location)) # For Search
            @is_search = true
            @selected_param.search = params[:search]
            @selected_param.location = params[:location]

            query                   = params[:search].presence || "*"
            args                    = {}
            args                    = args.merge(end_date: {gte: Time.now})
            args[:location]         = Array(params[:location]) if params[:location].present?

            @job_searchs = CompanyJob.search(query, 
                                            fields: ["title", "company_name", "category", "skill"], 
                                            where: args,
                                            order: {created_at: :desc},
                                            page: params[:page], per_page: 20)
        end
    end

    private

    def company_job_param
        params.require(:company_job).permit(:id, :title, :location, :description, :benefit, 
                                            :requirement, :salary, :quantity, :category, 
                                            :search, :end_date, :language, :level, :typical, 
                                            :urgent, :sponsor, :apply_another_site_flag, :apply_site, 
                                            :address, :experience, :policy, {:skill => []})
    end

    def filter_params
        filter_params = params.require(:filter).permit(:category, :salary, :level, :post_date, :typical, :search, :location)
    end
end
