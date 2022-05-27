class CompanyReactReplyInterviewQuestionsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company_reply_interview_question = CompanyReplyInterviewQuestion.find(params[:company_reply_interview_question_id])
        @company_react_reply_interview_questions = @company_reply_interview_question.company_react_reply_interview_questions
    end

    def new
        @company_reply_interview_question = CompanyReplyInterviewQuestion.find(params[:company_reply_interview_question_id])
        @company_react_reply_interview_question = CompanyReactReplyInterviewQuestion.new
    end

    def create
        @company_reply_interview_question = CompanyReplyInterviewQuestion.find(params[:company_reply_interview_question_id])

        @react = @company_reply_interview_question.company_react_reply_interview_questions.find { |react| (react.user_id == current_user.id) && (react.react_type == 0 || react.react_type == 1)}

        unless @react.nil?
            @react.update(react_type: params[:react_type])
        else
            # Created reactd
            @company_react_reply_interview_question = @company_reply_interview_question.company_react_reply_interview_questions.build(user_id: current_user.id, react_type: params[:react_type])
            @company_react_reply_interview_question.save!
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
        @company_reply_interview_question = CompanyReplyInterviewQuestion.find(params[:company_reply_interview_question_id])
        @company_react_reply_interview_question = @company_reply_interview_question.company_react_reply_interview_questions.find(params[:id])
        @company_react_reply_interview_question.destroy
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
