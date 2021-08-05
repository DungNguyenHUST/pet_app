class CompanyQuestionsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @company = Company.friendly.find(params[:company_id])
        @company_questions = @company.company_questions
    end

    def new
        @company = Company.friendly.find(params[:company_id])
        @company_question = CompanyQuestion.new
    end

    def create
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.build(company_question_param)

        if user_signed_in?
            @company_question.user_name = current_user.name
            @company_question.user_id = current_user.id
        end

        if @company_question.save
            redirect_to company_path(@company, tab_id: 'CompanyQuestionsID')
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*' "
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.find(params[:id])
        @company_question.destroy
        redirect_to company_path(@company, tab_id: 'CompanyquestionsID')
    end

    def show
        @company = Company.friendly.find(params[:company_id])
        @company_question = @company.company_questions.find(params[:id])
    end

    private

    def company_question_param
        params.require(:company_question).permit(:title, :content)
    end
end
