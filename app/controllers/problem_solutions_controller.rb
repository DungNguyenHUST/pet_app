class ProblemSolutionsController < ApplicationController
    include ApplicationHelper
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index 
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solutions = @problem.problem_solutions
    end

    def new
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = ProblemSolution.new
    end

    def create
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.build(problem_solution_param)
        @problem_solution.user_name = current_user.name
        @problem_solution.user_id = current_user.id

        if @problem_solution.save
            if(find_owner_user(@problem).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@problem), current_user, @problem.title, @problem_solution.title, problem_path(@problem, tab_id: 'ProblemSolutionID'), "ProblemComment")
            end
            redirect_to problem_path(@problem, tab_id: 'ProblemSolutionID')
        else
            flash[:danger] = "Lỗi, hãy điền nội dung câu trả lời của bạn ..."
            redirect_to problem_path(@problem, tab_id: 'ProblemSolutionID')
        end
    end

    def edit
        @problem = Problem.friendly.find params[:problem_id]
        @problem_solution = @problem.problem_solutions.friendly.find(params[:id])
    end

    def update
        @problem = Problem.friendly.find params[:problem_id]
        @problem_solution = @problem.problem_solutions.friendly.find(params[:id])
        if(@problem_solution.update(problem_solution_param))
            redirect_to pages_path
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
        end
    end
    
    def destroy
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:id])
        @problem_solution.destroy
        redirect_to problem_path(@problem, tab_id: 'ProblemSolutionID')
    end

    def show
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:id])
    end

    private

    def problem_solution_param
        params.require(:problem_solution).permit(:user_name, :title , :content, :vote)
    end
end
