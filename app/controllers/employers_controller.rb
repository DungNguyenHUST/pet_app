class EmployersController < ApplicationController
    include EmployersHelper
    include CompaniesHelper
    include ApplicationHelper
    before_action :require_employer_login, only: [:index, :show, :edit, :update, :destroy, :job, :plan, :index_job, :index_apply, :index_cv, :cv_search]
    
    def index
        @employers = Employer.all
    end

    def new
        @employer = Employer.new
    end
    
    def create
        @employer = Employer.new(employer_params)
    end

    def show
        @employer = current_employer

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end
        
        @company_of_employer = find_company_of_employer(@employer)
    end

    def edit
        @employer = Employer.friendly.find params[:id]
    end

    def destroy
        @employer = Employer.friendly.find params[:id]
        @employer.destroy
        redirect_to admin_path(current_admin, tab: 'AdminEmployerID')
    end

    def update
        @employer = Employer.friendly.find params[:id]
        if(@employer.update(employer_params))
            redirect_to employer_path(current_employer)
            flash[:success] = I18n.t(:update_success)
        else
            flash[:danger] = I18n.t(:update_error)
        end
    end

    def wellcome
    end

    def job
        @company_job = CompanyJob.friendly.find(params[:id])
        @company_apply_jobs = @company_job.company_apply_jobs.page(params[:page]).per(20)
    end

    def plan
        @price = 0
        if(params.has_key?(:price))
            @price = params[:price].to_i * 1000

            # for cal price mode
            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end

    def index_job
        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        @employer = current_employer
        @company_of_employer = find_company_of_employer(@employer)

        @company_job_all = CompanyJob.where(:employer_id => @employer.id)
        @company_job_approving = CompanyJob.where(:approved => false, :employer_id => current_employer.id)
        @company_job_inprogress = @company_job_all.expire.approved
        @company_job_close_soons = @company_job_all.where("end_date >= ?", 3.day.ago.utc).approved
        @company_job_closes = @company_job_all.where("end_date <= ?", Time.now).approved
        if @tab == 'AllID'
            @company_job_of_employer = @company_job_all
        elsif @tab == 'ApprovingID'
            @company_job_of_employer = @company_job_approving
        elsif @tab == 'InProgressID'
            @company_job_of_employer = @company_job_inprogress
        elsif @tab == 'CloseSoonID'
            @company_job_of_employer = @company_job_close_soons
        elsif @tab == 'ExpireID'
            @company_job_of_employer = @company_job_closes
        else
            @company_job_of_employer = @company_job_all
        end
        @company_job_of_employer = @company_job_of_employer.order('created_at DESC')
        @company_job_of_employer = Kaminari.paginate_array(@company_job_of_employer).page(params[:page]).per(20)
    end

    def index_apply
        @employer = current_employer
        @company_of_employer = find_company_of_employer(@employer)
        @company_job_of_employer = find_job_of_employer(@employer).order('created_at DESC')
        @company_apply_jobs = []
        @company_job_of_employer.each do |company_job|
            @company_apply_jobs += company_job.company_apply_jobs.page(params[:page]).per(20)
        end
        @company_apply_jobs = Kaminari.paginate_array(@company_apply_jobs).page(params[:page]).per(20)
    end

    def index_cv
        @employer = current_employer
        @user_cvs = User.all.public.order('updated_at DESC').page(params[:page]).per(12)
    end

    def cv_search
        @user_cvs = User.all.public.order('created_at DESC').page(params[:page]).per(12)

        # Search
        @is_cv_searched = false
        if(params.has_key?(:search) && params.has_key?(:location))
            @is_cv_searched = true
            @cv_searchs = User.all

            unless params[:search].empty?
                @cv_searchs = @cv_searchs.search_user_associate_by_query(params[:search])
            end

            unless params[:location].empty?
                @cv_searchs = @cv_searchs.search_user_by_address(params[:location])
            end

            @cv_searchs = @cv_searchs.public.order('created_at DESC').page(params[:page]).per(12)
        end

        # Filter
        if params.has_key?(:filter)
            @cv_filtereds = User.all

            @search = nil
            @location = nil
            @school_level = nil
            @sex = nil
            @job_level = nil
            @job_exp = nil
            @updated_date = nil
            
            if filter_params[:search].present?
                @search = filter_params[:search]
            end

            if filter_params[:location].present?
                @location = filter_params[:location]
            end

            if filter_params[:school_level].present?
                @category = filter_params[:school_level]
            end

            if filter_params[:sex].present?
                @sex = filter_params[:sex]
            end

            if filter_params[:job_exp].present?
                @job_exp = filter_params[:job_exp]
            end

            if filter_params[:job_level].present?
                @job_level = filter_params[:job_level]
            end

            if filter_params[:updated_date].present?
                @post_date = filter_params[:updated_date].scan(/\d+/).map(&:to_i).first
            end

            @filter_params_input = filter_params_input.new(@school_level, @sex, @job_level, @job_exp, 
                                                                    @updated_date, @search, @location)

            @cv_filtereds = @cv_filtereds.filtered(@filter_params_input)
            @cv_filtereds = @cv_filtereds.public.order('created_at DESC').page(params[:page]).per(12)

            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end
    
    private

    def filter_params
        filter_params = params.require(:filter).permit(:school_level, :sex, :job_level, :job_exp, :updated_date, :search, :location)
    end

    def filter_params_input
        filter_params_input = Struct.new(:school_level,
                                        :sex,
                                        :job_level,
                                        :job_exp, 
                                        :updated_date,
                                        :search,
                                        :location)
    end

    def employer_params
        params.require(:employer).permit :name, :email, :password, :password_confirmation, :phone, :address, :avatar, :company_name, :company_id, :company_field, :approved
    end
end
