class PagesController < ApplicationController
    def index
        @users = User.all
        @companies = Company.all
        @company_jobs = CompanyJob.all
        @company_reviews = CompanyReview.all
        @posts = Post.all
        @problems = Problem.all
    end
end
