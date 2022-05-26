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

    @@current_interview_form_object = nil
    @@interview_question_count = 0

    def self.set_current_interview_form_object(object)
        @@current_interview_form_object = object
    end

    def self.get_current_interview_form_object
        return @@current_interview_form_object
    end

    def self.get_interview_question_count
        return @@interview_question_count
    end

    def self.set_interview_question_count
        @@interview_question_count = 0
    end

    def add
        @@interview_question_count += 1
        @count = CompanyInterviewQuestionsController.get_interview_question_count
        @f = CompanyInterviewQuestionsController.get_current_interview_form_object
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    private

    def company_interview_question_param
        params.require(:company_interview_question).permit(:question, :user_id, :company_interview_id)
    end
end
