class ProblemSolutionsController < ApplicationController
    def index 
        @problem = Problem.find(params[:problem_id])
        @problem_solutions = @problem.problem_solutions
    end

    def new
        @problem = Problem.find(params[:problem_id])
        @problem_solution = ProblemSolution.new
    end

    def create
        @problem = Problem.find(params[:problem_id])

        @problem_solution = @problem.problem_solutions.build(problem_solution_param)

        if logged_in?
            @problem_solution.user_name = @current_user.name
        else
            @problem_solution.user_name = "Ẩn danh"
        end

        if @problem_solution.save
            redirect_to problem_path(@problem)
        else
            flash[:danger] = "Comment lỗi?"
            render :new
        end
    end
    
    def destroy
        @problem = Problem.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.find(params[:id])
        @problem_solution.destroy
        redirect_to problem_path(@problem)
    end

    def show
        @problem = Problem.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.find(params[:id])
    end

    private

    def problem_solution_param
        params.require(:problem_solution).permit(:user_name, :title , :content, :vote, :solution_rich)
    end
end
