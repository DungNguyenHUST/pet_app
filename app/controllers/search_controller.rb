class SearchController < ApplicationController
	def index
		@companies = Company.all.approved.order('name ASC').page(params[:page]).per(12)
		@company_jobs = CompanyJob.all.approved.order('created_at DESC').page(params[:page]).per(12)
		
		if(params.has_key?(:search) && params.has_key?(:location))
			@search = params[:search]
			@location = params[:location]
			@company_searchs = Company.friendly.search_advance(@search, @location).approved.order('name ASC').page(params[:page]).per(12)
			@job_searchs = CompanyJob.friendly.search_advance(@search, @location).approved.order('created_at DESC').page(params[:page]).per(12)
		end
	end
end
