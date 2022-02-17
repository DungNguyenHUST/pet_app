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
        if params.has_key?(:filter) # For Filter
            @is_cv_filtered = true
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
            @cv_filtereds = @cv_filtereds.public.reorder('updated_at DESC').page(params[:page]).per(12)
        elsif(params.has_key?(:search) && params.has_key?(:location)) # For Search
            @is_cv_searched = true
            @cv_searchs = User.all

            unless params[:search].empty?
                @cv_searchs = @cv_searchs.search_user_associate_by_query(params[:search])
            end

            unless params[:location].empty?
                @cv_searchs = @cv_searchs.search_user_by_address(params[:location])
            end

            @cv_searchs = @cv_searchs.public.reorder('updated_at DESC').page(params[:page]).per(12)
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
        params.require(:employer).permit( :name, :email, :password, :password_confirmation, :phone, :address, 
                                        :avatar, :company_name, :company_id, :company_field, :approved,
                                        :limit_cost, :remain_cost, :promotion_cost, :use_cost_seq, :cost_status)
    end
end
