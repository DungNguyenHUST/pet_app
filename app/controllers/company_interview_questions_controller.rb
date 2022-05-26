class CompanyInterviewQuestionsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:edit, :update, :destroy]

    def index 
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_interview_questions = @company_interview.company_interview_questions
    end

    def new
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company_interview_question = CompanyInterviewQuestion.new
    end

    def create
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company_interview_question = @company_interview.company_interview_questions.build(company_interview_question_param)
        
        if user_signed_in?
            @company_interview_question.user_id = current_user.id
        end

        @company_interview_question.save!
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company_interview = CompanyInterview.find(params[:company_interview_id])
        @company = @company_interview.company
        @company_interview_question = @company_interview.company_interview_questions.find(params[:id])

        @company_interview_question.destroy
        redirect_to company_path(@company, tab: 'CompanyInterviewsID')
    end

    def show
        @company_interview_question = CompanyInterviewQuestion.friendly.find(params[:id])
        @company_interview = @company_interview_question.company_interview
        @company_reply_interview_questions = @company_interview_question.company_reply_interview_questions.order('created_at DESC').page(params[:page]).per(2)
    end

    private

    def company_interview_question_param
        params.require(:company_interview_question).permit(:question, :user_id, :company_interview_id)
    end
end
