class CompanyReplyQuestionsController < ApplicationController
    include ApplicationHelper
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_questions = @company.company_questions
        @company_reply_questions = @company_questions.company_reply_questions
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.friendly.find(params[:company_question_id])
        @company_reply_question = CompanyReplyQuestion.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.friendly.find(params[:company_question_id])
        @company_reply_question = @company_question.company_reply_questions.build(company_reply_question_param)
        @company_reply_question.user_name = current_user.name
        @company_reply_question.user_id = current_user.id

        if @company_reply_question.save
            if(find_owner_user(@company_question).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@company_question), current_user, @company_question.title, @company_reply_question.reply_content, company_path(@company, tab_id: 'CompanyQuestionsID'), "QuestionComment")
            end
            # redirect_to company_path(@company, tab_id: 'CompanyquestionsID')
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.friendly.find(params[:company_question_id])
        @company_reply_question = @company_question.company_reply_questions.friendly.find(params[:id])

        @company_reply_question.destroy
        redirect_to company_path(@company, tab_id: 'CompanyquestionsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.friendly.find(params[:company_question_id])
        @company_reply_question = @company_question.company_reply_questions.friendly.find(params[:id])
    end

    private

    def company_reply_question_param
        params.require(:company_reply_question).permit(:reply_content)
    end
end
