class PagesController < ApplicationController
    def index
        @user = User.new
        @companies = Company.all
        @company_jobs = CompanyJob.all
        @company_reviews = CompanyReview.all
    end
end
