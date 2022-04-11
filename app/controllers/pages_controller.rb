class PagesController < ApplicationController
    def home
		@company_jobs = CompanyJob.all.order('created_at DESC').expire
		
        if admin_signed_in?
			redirect_to admin_path(current_admin)
		elsif employer_signed_in?
			redirect_to employer_path(current_employer)
		end
    end

	# passing selected company to new review path
	def select_company
		if(params.has_key?(:company_id))
			@company_id = params[:company_id]
			redirect_to new_company_company_review_path(@company_id)
		end
	end

	def review
		@companies = Company.all.page(params[:page]).per(18)
		@company_reviews = CompanyReview.all.order('created_at DESC').page(params[:page]).per(18)
		
		# Search
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true

            # Auto complete
            @suggest_companies = Company.search_company_by_name(params[:search])
            respond_to do |format|
                format.html {}
                format.json {
                    @suggest_companies = @suggest_companies.limit(10)
                }
            end

            # Search result
			@company_searchs = Company.search_company_by_name(params[:search]).reorder('name ASC').page(params[:page]).per(12)

			# Redirect to first company result
			if @company_searchs.total_count > 0
				redirect_to company_path(@company_searchs.first, tab: "CompanyReviewsID")
				return
			end
		end
	end

	def interview
		@companies = Company.all.page(params[:page]).per(18)
		@company_interviews = CompanyInterview.all.order('created_at DESC').page(params[:page]).per(18)
		
		# Search
        @is_company_searched = false
		if(params.has_key?(:search))
            @is_company_searched = true

            # Auto complete
            @suggest_companies = Company.search_company_by_name(params[:search])
            respond_to do |format|
                format.html {}
                format.json {
                    @suggest_companies = @suggest_companies.limit(10)
                }
            end

            # Search result
			@company_searchs = Company.search_company_by_name(params[:search]).reorder('name ASC').page(params[:page]).per(12)

			# Redirect to first company result
			if @company_searchs.total_count > 0
				redirect_to company_path(@company_searchs.first, tab: "CompanyInterviewsID")
				return
			end
		end
	end
end
