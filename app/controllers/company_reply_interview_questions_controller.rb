class CompanyReplyInterviewQuestionsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:edit, :update, :destroy]

    def index
    end

    def new
        @company_interview_question = CompanyInterviewQuestion.find(params[:company_interview_question_id])
        @company_reply_interview_question = CompanyReplyInterviewQuestion.new
    end

    def create
        @company_interview_question = CompanyInterviewQuestion.find(params[:company_interview_question_id])
        @company_reply_interview_question = @company_interview_question.company_reply_interview_questions.build(company_reply_interview_question_param)

        if user_signed_in?
            @company_reply_interview_question.user_id = current_user.id
        end

        if @company_reply_interview_question.save
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = I18n.t(:create_error)
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
    end

    def show
    end

    private

    def company_reply_interview_question_param
        params.require(:company_reply_interview_question).permit(:user_id, :answer, :company_interview_question_id)
    end
end
