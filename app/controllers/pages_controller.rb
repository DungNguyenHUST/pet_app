class PagesController < ApplicationController
    def index
        @user = User.new
        @companies = Company.all
        @company_jobs = CompanyJob.all
    end
end
