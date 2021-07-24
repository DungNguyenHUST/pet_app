class PagesController < ApplicationController
    def home
		if user_signed_in? && current_user.admin?
			@users = User.all
			@companies = Company.all
			@company_jobs = CompanyJob.all
			@posts = Post.all
			@problems = Problem.all
		else
			@users = User.all
			@companies = Company.all.approved.sort_by{|company| company.company_reviews.count}.reverse
			@company_jobs = CompanyJob.all.order('created_at DESC').approved
			@posts = Post.all.order('created_at DESC').approved
			@problems = Problem.all.approved.sort_by{|problem| problem.problem_solutions.count}.reverse
		end

		if(params.has_key?(:company_search))
		    @company_search = params[:company_search]
            @company_searchs = Company.friendly.search(@company_search)
        end

        if(params.has_key?(:job_search))
		    @job_search = params[:job_search]
            @job_searchs = CompanyJob.friendly.search(@job_search)
        end

        if(params.has_key?(:user_search))
            @user_search = params[:user_search]
            @user_searchs = User.friendly.search(@user_search)
        end

        if(params.has_key?(:post_search))
            @post_search = params[:post_search]
            @post_searchs = Post.friendly.search(@post_search)
        end

        if(params.has_key?(:problem_search))
            @problem_search = params[:problem_search]
            @problem_searchs = Problem.friendly.search(@problem_search)
        end

		if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end
		
        if user_signed_in?
			if current_user.admin? || (current_user.employer? && current_user.approved?)
				redirect_to user_path(current_user, tab_id: @tab_id)
			end
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
