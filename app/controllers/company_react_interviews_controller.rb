class CompanyReactInterviewsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company_react_interviews = @company_interview.company_react_interviews
    end

    def new
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company_react_interview = CompanyReactInterview.new
    end

    def create
        @company_interview = CompanyInterview.find(params[:company_interview_id])

        @react = @company_interview.company_react_interviews.find { |react| (react.user_id == current_user.id) && (react.react_type == 0 || react.react_type == 1)}

        unless @react.nil?
            @react.update(react_type: params[:react_type])
        else
            # Created reactd
            @company_react_interview = @company_interview.company_react_interviews.build(user_id: current_user.id, react_type: params[:react_type])
            @company_react_interview.save!
        end

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company_react_interview = @company_interview.company_react_interviews.find(params[:id])
        @company_react_interview.destroy
        @type_param = params[:type_param]

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
    end

    private
end
