class EmployersController < ApplicationController
    include EmployersHelper
    include CompaniesHelper
    include ApplicationHelper
    before_action :require_employer_login, only: [:index, :show, :edit, :update, :destroy, :job, :plan, :buy, :mng_job, :mng_apply, :cv_search]
    
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
        @company_of_employer = find_company_of_employer(@employer)

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end
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

        if(employer_params.has_key?(:limit_cost)) # Update limit cost setting
            if @employer.remain_cost
                if employer_params[:limit_cost].to_i <= @employer.remain_cost.to_i
                    if @employer.update(employer_params)
                        flash[:success] = I18n.t(:update_success)
                    end
                else
                    flash[:danger] = I18n.t(:not_enough_cost_warning)
                end
            else
                flash[:danger] = I18n.t(:not_enough_cost_warning)
            end
            redirect_to employer_buy_path
        else # Normal update
            if(@employer.update(employer_params))
                redirect_to employer_path(current_employer)
                flash[:success] = I18n.t(:update_success)
            else
                flash[:danger] = I18n.t(:update_error)
            end
        end
    end

    def wellcome
    end

    def job
        @company_job = CompanyJob.friendly.find(params[:id])
        @company_apply_jobs = @company_job.company_apply_jobs.page(params[:page]).per(20)
    end

    def ad
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

    def buy
        @employer = current_employer
        @employer_costs = @employer.employer_costs.order('created_at DESC').page(params[:page]).per(10)
        @employer_bills = @employer.employer_bills.order('created_at DESC').page(params[:page]).per(10)
        
        if(params.has_key?(:company_job_id))
            @company_job = CompanyJob.friendly.find(params[:company_job_id])
            if @company_job.approved?
                if @employer.cost_status == 1
                    if @company_job.sponsor == 1
                        @company_job.update(:sponsor => 0)
                    else
                        @company_job.update(:sponsor => 1)
                    end
                    @company_job.save!
                elsif @employer.cost_status == 0
                    flash[:danger] = I18n.t(:not_enough_cost_warning)
                else
                    flash[:danger] = I18n.t(:not_enough_cost_daily_warning)
                end
            else
                flash[:danger] = I18n.t(:approving_job_warning)
            end
            redirect_to employer_mng_job_path
            return
        end

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end
    end

    def mng_job
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

    def mng_apply
        @employer = current_employer
        @company_of_employer = find_company_of_employer(@employer)
        @company_job_of_employer = find_job_of_employer(@employer).order('created_at DESC')
        @company_apply_jobs_all_of_employer = []
        @company_job_of_employer.each do |company_job|
            @company_apply_jobs_all_of_employer += company_job.company_apply_jobs.order('created_at DESC')
        end

        @company_apply_jobs_of_employer_new = @company_apply_jobs_all_of_employer.find_all { |apply| apply.process == 0 }
        @company_apply_jobs_of_employer_contacting = @company_apply_jobs_all_of_employer.find_all { |apply| apply.process == 1 }
        @company_apply_jobs_of_employer_interview = @company_apply_jobs_all_of_employer.find_all { |apply| apply.process == 2 }
        @company_apply_jobs_of_employer_success = @company_apply_jobs_all_of_employer.find_all { |apply| apply.process == 3 }
        @company_apply_jobs_of_employer_fail = @company_apply_jobs_all_of_employer.find_all { |apply| apply.process == 4 }

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end
        
        if @tab == 'AllID'
            @company_apply_jobs_of_employer = @company_apply_jobs_all_of_employer
        elsif @tab == 'NewID'
            @company_apply_jobs_of_employer = @company_apply_jobs_of_employer_new
        elsif @tab == 'ContactingID'
            @company_apply_jobs_of_employer = @company_apply_jobs_of_employer_contacting
        elsif @tab == 'InterviewID'
            @company_apply_jobs_of_employer = @company_apply_jobs_of_employer_interview
        elsif @tab == 'SuccessID'
            @company_apply_jobs_of_employer = @company_apply_jobs_of_employer_success
        elsif @tab == 'FailID'
            @company_apply_jobs_of_employer = @company_apply_jobs_of_employer_fail
        else
            @company_apply_jobs_of_employer = @company_apply_jobs_all_of_employer
        end
        @company_apply_jobs_of_employer = Kaminari.paginate_array(@company_apply_jobs_of_employer).page(params[:page]).per(20)
    end

    def help
        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end
    end

    def cv_search
        @employer = current_employer
        @user_cvs = User.all.public.order('updated_at DESC').page(params[:page]).per(12)

        @is_cv_searched = false
        @is_cv_filtered = false

        st_selected = Struct.new(:school_level, :sex, :job_level, :job_exp, :updated_date, :search, :location) 
        @selected_param = st_selected.new()

        if params.has_key?(:filter) # For Filter
            @is_cv_filtered = true

            @selected_param = st_selected.new(filter_params[:school_level], filter_params[:sex], filter_params[:job_level], filter_params[:job_exp], 
                                            filter_params[:updated_date], filter_params[:search], filter_params[:location])

            query                                   = filter_params[:search].presence || "*"
            args                                    = {}
            args                                    = args.merge(public: false)
            args[:address]                          = Array(params[:location]) if params[:location].present?
            args[:user_educations_school_level]     = Array(filter_params[:school_level]) if filter_params[:school_level].present?
            args[:sex]                              = Array(filter_params[:sex]) if filter_params[:sex].present?
            args[:user_experiences_job_level]       = Array(filter_params[:job_level]) if filter_params[:job_level].present?            
            args                                    = args.merge(user_experiences_time: {gte: filter_params[:job_exp].scan(/\d+/).map(&:to_i).first}) if filter_params[:job_exp].present?
            args                                    = args.merge(updated_at: {gte: (Time.now - filter_params[:updated_date].scan(/\d+/).map(&:to_i).first.days)}) if filter_params[:updated_date].present?

            @cv_filtereds = User.search(query, 
                                        fields: ["name", \
                                                "user_educations_school_name", \
                                                "user_educations_school_field", \
                                                "user_educations_school_level", \
                                                "user_educations_cert_type", \
                                                "user_educations_cert_level", \
                                                "user_experiences_job_level", \
                                                "user_experiences_company_name", \
                                                "user_adwards", \
                                                "user_certificates", \
                                                "user_skills"], \
                                        where: args,
                                        # order: {updated_at: :desc},
                                        page: params[:page], per_page: 12)

        elsif(params.has_key?(:search) && params.has_key?(:location)) # For Search
            @is_cv_searched = true

            @selected_param.search = params[:search]
            @selected_param.location = params[:location]

            query                   = params[:search].presence || "*"
            args                    = {}
            args                    = args.merge(public: false)
            args[:address]          = Array(params[:location]) if params[:location].present?

            @cv_searchs = User.search(query, 
                                    fields: ["name", \
                                            "user_educations_school_name", \
                                            "user_educations_school_field", \
                                            "user_educations_school_level", \
                                            "user_educations_cert_type", \
                                            "user_educations_cert_level", \
                                            "user_experiences_job_level", \
                                            "user_experiences_company_name", \
                                            "user_adwards", \
                                            "user_certificates", \
                                            "user_skills"], \
                                    where: args,
                                    # order: {updated_at: :desc},
                                    page: params[:page], per_page: 12)
        end
    end
    
    private

    def filter_params
        filter_params = params.require(:filter).permit(:school_level, :sex, :job_level, :job_exp, :updated_date, :search, :location)
    end

    def employer_params
        params.require(:employer).permit( :name, :email, :password, :password_confirmation, :phone, :address, 
                                        :avatar, :company_name, :company_id, :company_field, :approved,
                                        :limit_cost, :remain_cost, :promotion_cost, :use_cost_seq, :cost_status)
    end
end
