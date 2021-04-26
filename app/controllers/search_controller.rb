class SearchController < ApplicationController
	def index
		@companies = Company.all.approved
		@company_jobs = CompanyJob.all.approved
		
		if(params.has_key?(:search) && params.has_key?(:location))
			@search = params[:search]
			@location = params[:location]
			@company_searchs = Company.friendly.search_advance(@search, @location).approved
			@job_searchs = CompanyJob.friendly.search_advance(@search, @location).approved
		end
	end
end
