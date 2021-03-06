class CompanyFollowsController < ApplicationController
    # before_action :find_company_follow
    
    def index 
        @company = Company.find(params[:company_id])
        @company_follows = @company.company_follows
    end

    def new
        @company = Company.find(params[:company_id])
        @company_follow = CompanyFollow.new
    end

    def create
        @company = Company.find(params[:company_id])
        if logged_in?
            if already_followed?
                # flash[:notice] = "You can't like more than once"
            else                
                @company_follow = @company.company_follows.create(user_id: current_user.id)
            end
            # redirect_to company_path(@company)
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            redirect_to login_path
        end
    end
    
    def destroy
        @company = Company.find(params[:company_id])
        @company_follow = @company.company_follows.find(params[:id])
        @company_follow.destroy
        # redirect_to company_path(@company)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @company = Company.find(params[:company_id])
        @company_follow = @company.company_follows.find(params[:id])
    end

    private

    def company_follow_param
        # params.require(:company_follow).permit(:id)
    end

    def already_followed?
        CompanyFollow.where(user_id: current_user.id, company_id: params[:company_id]).exists?
    end

    def find_company_follow
        @company = Company.find(params[:company_id])
        @company_follow = CompanyFollow.find(params[:id])
    end
end
