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
            flash[:success] = "Update thông tin thành công"
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
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
            search_data = search_params.new(params[:search], params[:location])
            @cv_searchs = search_cv(search_data).sort_by{|cv| cv.updated_at}.reverse
            @cv_searchs = Kaminari.paginate_array(@cv_searchs).page(params[:page]).per(10)
        end

        # Filter
        if params.has_key?(:filter)
            search_data = search_params.new(filter_params[:search], filter_params[:location])
            @cv_searchs = search_cv(search_data).sort_by{|cv| cv.updated_at}.reverse

            filter_data = filter_params_converted.new(filter_params[:edu],
                                                                filter_params[:sex],
                                                                filter_params[:level],
                                                                filter_params[:post_date], 
                                                                filter_params[:experience],
                                                                filter_params[:search],
                                                                filter_params[:location])
            @cv_filtereds = filter_cv(@cv_searchs, filter_data).sort_by{|cv| cv.updated_at}.reverse
            
            @cv_searchs = Kaminari.paginate_array(@cv_searchs).page(params[:page]).per(10)
            @cv_filtereds = Kaminari.paginate_array(@cv_filtereds).page(params[:page]).per(10)

            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end
    
    private

    def filter_params
        filter_params = params.require(:filter).permit(:edu, :sex, :level, :post_date, :experience, :search, :location)
    end

    def search_params
        search_param = Struct.new(:search, :location)
    end

    def filter_params_converted
        filter_params_converted = Struct.new(:edu,
                                            :sex,
                                            :level,
                                            :post_date, 
                                            :experience,
                                            :search,
                                            :location)
    end

    def employer_params
        params.require(:employer).permit :name, :email, :password, :password_confirmation, :phone, :address, :avatar, :company_name, :company_id, :company_field, :approved
    end
end
