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
        if @company_job.sponsor == 1
            if @employer = find_employer_of_job(@company_job)
                if auth_used_cost_of_employer(@employer) == false
                    @employer.update(:cost_status => 2) # Temprory stop cost in daily
                    @company_job.update(:sponsor => 0)
                else
                    @employer.employer_costs.create(:cost => COST_PEER_VIEW, :url => company_job_path(@company_job))
                    remain_cost = @employer.remain_cost - COST_PEER_VIEW
                    if remain_cost < 0
                        remain_cost = 0
                        @employer.update(:cost_status => 0) # Stop cost when no cost remain
                        @company_job.update(:sponsor => 0)
                    end
                    @employer.update(:remain_cost => remain_cost)
                end
            end
        elsif @company_job.sponsor == 0
            if @employer = find_employer_of_job(@company_job)
                if @employer.cost_status == 2 && auth_used_cost_of_employer(@employer) == true # In case temprory stop cost, resume in next day
                    @company_job.update(:sponsor => 1)
                    @employer.update(:cost_status => 1)
                end
            end
        end
        
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
            @suggest_jobs = CompanyJob.search_job_by_query(params[:search])
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
		if(params.has_key?(:search) || params.has_key?(:location))
            @is_search = true
            @job_searchs = CompanyJob.all

            if params.has_key?(:search)
                unless params[:search].empty?
                    @job_searchs = @job_searchs.search_job_by_query(params[:search])
                end
            end
            
            if params.has_key?(:location)
                unless params[:location].empty?
                    @job_searchs = @job_searchs.search_job_by_location(params[:location])
                end
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
                                            :urgent, :sponsor, :apply_another_site_flag, :apply_site, 
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
