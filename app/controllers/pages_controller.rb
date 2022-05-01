include ApplicationHelper
class PagesController < ApplicationController
    def home
		if search_track = find_last_search_of_visitor
			@company_jobs = CompanyJob.search(search_track.query[:search], 
															fields: ["title^10", "company_name^5", "category", "skill"], 
															order: {created_at: :desc},
															page: params[:page], per_page: 10)
		end

		@is_last_visit = false
		if @company_jobs
			if @company_jobs.total_count < 9
				@company_jobs = CompanyJob.all.order('created_at DESC').expire
			else
				@is_last_visit = true
			end
		else
			@company_jobs = CompanyJob.all.order('created_at DESC').expire
		end

		@company_jobs = @company_jobs.first(9)

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
            @company_searchs = Company.search(params[:search], fields: ["name"])
            respond_to do |format|
                format.html {}
                format.json {
                    @suggest_companies = @company_searchs.limit(10)
                }
            end
			
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
			@company_searchs = Company.search(params[:search], fields: ["name"])
            respond_to do |format|
                format.html {}
                format.json {
                    @suggest_companies = @company_searchs.limit(10)
                }
            end

			# Redirect to first company result
			if @company_searchs.total_count > 0
				redirect_to company_path(@company_searchs.first, tab: "CompanyInterviewsID")
				return
			end
		end
	end
end
