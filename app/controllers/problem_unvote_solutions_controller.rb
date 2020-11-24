class ProblemUnvoteSolutionsController < ApplicationController
    before_action :find_problem_solution
    before_action :find_unvote, only: [:destroy]
    
    def index 
        @problem = Problem.find(params[:problem_id])
        @problem_solutions = @problem.problem_solutions
        @problem_unvote_solutions = @problem_solutions.problem_unvote_solutions
    end

    def new
        @problem = Problem.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.find(params[:problem_solution_id])
        @problem_unvote_solution = ProblemUnvoteSolution.new
    end

    def create
        @problem = Problem.find(params[:problem_id])
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        if logged_in?
            if already_unvoted?
                flash[:notice] = "You can't unvote more than once"
            else
                @problem_unvote_solution = @problem_solution.problem_unvote_solutions.create(user_id: current_user.id)
            end
            redirect_to problem_path(@problem)
        else
            redirect_to login_path
        end
    end
    
    def destroy
        @problem = Problem.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.find(params[:problem_solution_id])
        @problem_unvote_solution = @problem_solution.problem_unvote_solutions.find(params[:id])
        @problem_unvote_solution.destroy
        redirect_to problem_path(@problem)
    end

    def show
        @problem = Problem.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.find(params[:problem_solution_id])
        @problem_unvote_solution = @problem_solution.problem_unvote_solutions.find(params[:id])
    end

    private

    def problem_unvote_solution_param
        # params.require(:problem_unvote_solution).permit(:unvote_content)
    end

    def already_unvoted?
        ProblemUnvoteSolution.where(user_id: current_user.id, problem_solution_id: params[:problem_solution_id]).exists?
    end

    def find_problem_solution
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
    end

    def find_unvote
        @unvote = @problem_solution.problem_unvote_solutions.find(params[:id])
    end
end
