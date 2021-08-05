class PagesController < ApplicationController
    def home
		@users = User.all
		@companies = Company.all.sort_by{|company| company.company_reviews.count}.reverse
		@company_jobs = CompanyJob.all.order('created_at DESC')
		@posts = Post.all.order('created_at DESC')
		@problems = Problem.all.approved.sort_by{|problem| problem.problem_solutions.count}.reverse
		
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
