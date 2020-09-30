class PagesController < ApplicationController
    def index
        @users = User.all
        @companies = Company.all
        @company_jobs = CompanyJob.all
        @company_reviews = CompanyReview.all
    end
end
