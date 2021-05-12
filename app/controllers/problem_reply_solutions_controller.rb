class ProblemReplySolutionsController < ApplicationController
    def index 
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solutions = @problem.problem_solutions
        @problem_reply_solutions = @problem_solutions.problem_reply_solutions
    end

    def new
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
        @problem_reply_solution = ProblemReplySolution.new
    end

    def create
        if logged_in?
            @problem = Problem.friendly.find(params[:problem_id])
            @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
            @problem_reply_solution = @problem_solution.problem_reply_solutions.build(problem_reply_solution_param)
            @problem_reply_solution.user_name = current_user.name
            @problem_reply_solution.user_id = current_user.id
        else
            redirect_to login_path
            return
        end

        if @problem_reply_solution.save
            redirect_to problem_path(@problem, tab_id: 'ProblemSolutionID')
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            # render :new
        end
    end
    
    def destroy
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
        @problem_reply_solution = @problem_solution.problem_reply_solutions.friendly.find(params[:id])

        @problem_reply_solution.destroy
        redirect_to problem_path(@problem, tab_id: 'ProblemSolutionID')
    end

    def show
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
        @problem_reply_solution = @problem_solution.problem_reply_solutions.friendly.find(params[:id])
    end

    private

    def problem_reply_solution_param
        params.require(:problem_reply_solution).permit(:reply_content)
    end
end
