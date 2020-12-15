class PagesController < ApplicationController
    def index
        @users = User.all
        @companies = Company.all
        @company_jobs = CompanyJob.all
        @company_reviews = CompanyReview.all
        @posts = Post.all
        @problems = Problem.all
        if logged_in?
            if current_user.employer
                # for company of employer
                @company_by_employer = @current_user.company
                @company_job_by_employer = @company_by_employer.company_jobs.all
            end
        end
    end
end
