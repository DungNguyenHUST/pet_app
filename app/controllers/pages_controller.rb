class PagesController < ApplicationController
    def home
		@company_jobs = CompanyJob.all.order('created_at DESC').expire
		
        if admin_signed_in?
			redirect_to admin_path(current_admin)
		end

		if employer_signed_in?
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
end
