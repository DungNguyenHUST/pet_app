class CompaniesController < ApplicationController
    include CompaniesHelper
    include ApplicationHelper
    before_action :require_employer_login, only: [:new, :create, :edit, :update, :destroy]
    
    # Index list
    @@popular_companies = nil
    @@best_companies = nil
    @@set_time = nil

    def set_popular_company
        if @@set_time
            if @@set_time <= (Time.now - 1.days) # set new list on each days
                @@popular_companies = Company.all.sort_by{|company| company.company_reviews.count}.reverse
                @@best_companies = Company.all.sort_by{|company| cal_rating_review_total_score(company).to_f}.reverse
                @@set_time = Time.now
            else
                return
            end
        else
            @@popular_companies = Company.all.sort_by{|company| company.company_reviews.count}.reverse
            @@best_companies = Company.all.sort_by{|company| cal_rating_review_total_score(company).to_f}.reverse
            @@set_time = Time.now
        end
    end

    def index
        add_breadcrumb I18n.t(:home_page), :root_path
        add_breadcrumb I18n.t(:company_list), :companies_path

        # Set popular list
        self.set_popular_company

        # Search
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true

            @company_searchs = Company.search(params[:search], 
                                            fields: ["name"], 
                                            page: params[:page], per_page: 12)

            # Auto complete
            respond_to do |format|
                format.html {}
                format.json {
                    @suggest_companies = @company_searchs.limit(10)
                }
            end
		end
        
        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        @companies = Company.all.page(params[:page]).per(18)

        if @tab == "default" || @tab == "CompanyMostRecentID"
            @companies_most_recent = Kaminari.paginate_array(@@popular_companies).page(params[:page]).per(18)
        end

        if @tab == "CompanyBestID"
            @companies_best = Kaminari.paginate_array(@@best_companies).page(params[:page]).per(18)
        end
    end

    def list
    end

    def new
        @company = Company.new
    end

    def create
        @company = Company.new(company_param)
        if employer_signed_in?
            @company.employer_id = current_employer.id
        end

        if @company.save!
            if employer_signed_in?
                redirect_to employer_path(current_employer, tab: 'EmployerCompanyID')
            else
                redirect_to company_path(@company)
            end
        else
            flash[:danger] = I18n.t(:create_error)
            render :new
        end
    end

    def show
        @company = Company.friendly.find params[:id]
        @company_reviews = @company.company_reviews.order('created_at DESC').page(params[:page]).per(10)
        @company_interviews = @company.company_interviews.order('created_at DESC').page(params[:page]).per(10)
        @company_jobs = find_job_of_company(@company).order('created_at DESC').page(params[:page]).per(10)
        @company_questions = @company.company_questions.order('created_at DESC').page(params[:page]).per(10)
        @company_images = @company.company_images.order('created_at DESC').page(params[:page]).per(12)

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        add_breadcrumb I18n.t(:home_page), :root_path
        add_breadcrumb I18n.t(:company_list), :companies_path
        add_breadcrumb @company.name, company_path(@company)
        if @tab == "CompanyProfileID"
            add_breadcrumb I18n.t(:overview), company_path(@company)                        
        elsif @tab == "CompanyPolicyID"
            add_breadcrumb I18n.t(:policy), company_path(@company) 
        elsif  @tab == "CompanyReviewsID"
            # For review chart graph
            @chart_review = {}
            @chart_review_group = @company.company_reviews.group_by_month { |u| u.created_at }.to_hash
            @company_review_list = []
            @chart_review_group.each_key do |key|
                @chart_review_group[key].each do |value|
                    @company_review_list.push(CompanyReview.find_by_id(value.id))
                end
                @chart_review[key] = cal_rating_review_score_list(@company_review_list).to_f
            end
            
            # For sort
            if(params.has_key?(:sort_tab))
                @sort_tab = params[:sort_tab]
            else
                @sort_tab = "default"
            end
    
            if @sort_tab == "default" || @sort_tab == "ReviewNewID"
                @company_reviews = @company.company_reviews.order('created_at DESC').page(params[:page]).per(10)
            end
    
            if @sort_tab == "ReviewPopularID"
                @company_reviews = @company.company_reviews.sort_by{|company_review| company_review.company_react_reviews.count}.reverse
                @company_reviews = Kaminari.paginate_array(@company_reviews).page(params[:page]).per(10)
            end

            if @sort_tab == "ReviewLowtoHighID"
                @company_reviews = @company.company_reviews.sort_by{|company_review| cal_rating_review_score(company_review).to_f}
                @company_reviews = Kaminari.paginate_array(@company_reviews).page(params[:page]).per(10)
            end

            if @sort_tab == "ReviewHightoLowID"
                @company_reviews = @company.company_reviews.sort_by.sort_by{|company_review| cal_rating_review_score(company_review).to_f}.reverse
                @company_reviews = Kaminari.paginate_array(@company_reviews).page(params[:page]).per(10)
            end
            
            add_breadcrumb I18n.t(:review), company_path(@company)
        elsif  @tab == "CompanyInterviewsID"
            # For sort
            if(params.has_key?(:sort_tab))
                @sort_tab = params[:sort_tab]
            else
                @sort_tab = "default"
            end
    
            if @sort_tab == "default" || @sort_tab == "InterviewNewID"
                @company_interviews = @company.company_interviews.order('created_at DESC').page(params[:page]).per(10)
            end
    
            if @sort_tab == "InterviewPopularID"
                @company_interviews = @company.company_interviews.sort_by{|company_interview| company_interview.company_react_interviews.count}.reverse
                @company_interviews = Kaminari.paginate_array(@company_interviews).page(params[:page]).per(10)
            end

            add_breadcrumb I18n.t(:interview), company_path(@company)
        elsif @tab == "CompanyJobsID"
            add_breadcrumb I18n.t(:job), company_path(@company)
        elsif @tab == "CompanySalariesID"
            add_breadcrumb I18n.t(:salary), company_path(@company)
        elsif  @tab == "CompanyQuestionsID"
            # For sort
            if(params.has_key?(:sort_tab))
                @sort_tab = params[:sort_tab]
            else
                @sort_tab = "default"
            end
    
            if @sort_tab == "default" || @sort_tab == "QuestionNewID"
                @company_questions = @company.company_questions.order('created_at DESC').page(params[:page]).per(10)
            end
    
            if @sort_tab == "QuestionPopularID"
                @company_questions = @company.company_questions.sort_by{|company_question| company_question.company_reply_questions.count}.reverse
                @company_questions = Kaminari.paginate_array(@company_questions).page(params[:page]).per(10)
            end

            add_breadcrumb I18n.t(:question), company_path(@company) 
        elsif  @tab == "CompanyImagesID"
            add_breadcrumb I18n.t(:picture), company_path(@company)
        end
    end

    def edit
        @is_edit = params[:is_edit]
        @company = Company.friendly.find params[:id]
    end

    def update
        @company = Company.friendly.find params[:id]
        if(@company.update(company_param))
            flash[:danger] = I18n.t(:update_success)
            redirect_to company_path(@company)
        else
            flash[:danger] = I18n.t(:update_error)
        end
    end

    def destroy
        @company = Company.friendly.find params[:id]
        @company.destroy
        redirect_to companies_path
    end

    private
    def company_param
        params.require(:company).permit(:name, :location, :address, :country, :website, :phone, :time_establish, :working_time, :working_date, :size, :field_operetion, :avatar, :search, :overview, :policy, :values, :company_type, :employer_id, {:benefit => []})
    end
end
