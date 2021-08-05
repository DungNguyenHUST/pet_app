class SearchController < ApplicationController
	def index
		@companies = Company.all.order('name ASC').page(params[:page]).per(12)
		@company_jobs = CompanyJob.all.order('created_at DESC').page(params[:page]).per(12)
		
		if(params.has_key?(:search) && params.has_key?(:location))
			@search = params[:search]
			@location = params[:location]
			if @location.to_s == "Tất cả địa điểm"
				@company_searchs = Company.friendly.search(@search).order('name ASC').page(params[:page]).per(12)
				@job_searchs = CompanyJob.friendly.search(@search).order('created_at DESC').page(params[:page]).per(12)
			else
				@company_searchs = Company.friendly.search_advance(@search, @location).order('name ASC').page(params[:page]).per(12)
				@job_searchs = CompanyJob.friendly.search_advance(@search, @location).order('created_at DESC').page(params[:page]).per(12)
			end
		end
	end
end
