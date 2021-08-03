class ReportsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @reports = Report.all
    end

    def new
        @report = Report.new
    end

    def create
        @report = Report.new(report_params)
        @report.user_id = current_user.id
        
        if @report.save
            respond_to do |format|
                format.html {}
                format.js
            end
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @report = Report.reports.find(params[:id])
        @report.destroy

        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
    end

    private

    def report_params
        params.require(:report).permit(:report_type, :report_content, :user_id, :target_id, :target_type)
    end
end
