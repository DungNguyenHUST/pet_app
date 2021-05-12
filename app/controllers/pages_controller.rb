class PagesController < ApplicationController
    def index
		if logged_in? && current_user.admin?
			@users = User.all
			@companies = Company.all
			@company_jobs = CompanyJob.all
			@company_reviews = CompanyReview
			@posts = Post.all
			# for problem
			@problems = Problem.all
			# count = 0
			# @problems_best = []
			# @problems.each do |problem|
			#     if problem.problem_solutions.count > count
			#         @problems_best.push(problem)
			#         count = problem.problem_solutions.count
			#     end
			# end
			@problems_best = Problem.all
		else
			@users = User.all
			@companies = Company.all.approved
			@company_jobs = CompanyJob.all.approved
			@company_reviews = CompanyReview.all
			@posts = Post.all.approved
			# for problem
			@problems = Problem.all.approved
			# count = 0
			# @problems_best = []
			# @problems.each do |problem|
			#     if problem.problem_solutions.count > count
			#         @problems_best.push(problem)
			#         count = problem.problem_solutions.count
			#     end
			# end
			@problems_best = Problem.all.approved
		end

        if logged_in?
            if current_user.employer
                # for company of employer
                @company_by_employer = current_user.company
                @company_job_by_employer = @company_by_employer.company_jobs.all
            end
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
    end
end
