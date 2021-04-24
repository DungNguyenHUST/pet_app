class SearchController < ApplicationController
	def index
		@companies = Company.all.approved
		@company_jobs = CompanyJob.all.approved
		
		@search = params[:search]
		@location = params[:location]
		@company_searchs = Company.friendly.search_advance(@search, @location).approved
		@job_searchs = CompanyJob.friendly.search_advance(@search, @location).approved
		
		# find company which incude job search
        @company_by_jobs = []
        Company.all.each do |company|
			if @job_search.present?
				@job_searchs.each do |job_search|
					if job_search.approved?
						if (company.id = job_search.company_id)
							@company_by_jobs.push(company)
						end
					end
				end
			end
        end
	end
end
