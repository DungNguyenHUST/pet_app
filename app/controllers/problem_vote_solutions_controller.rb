class ProblemVoteSolutionsController < ApplicationController
    before_action :find_problem_solution
    before_action :find_vote, only: [:destroy]
    
    def index 
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solutions = @problem.problem_solutions
        @problem_vote_solutions = @problem_solutions.problem_vote_solutions
    end

    def new
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
        @problem_vote_solution = ProblemVoteSolution.new
    end

    def create
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = ProblemSolution.friendly.find(params[:problem_solution_id])
        if logged_in?
            if already_voted?
                # flash[:notice] = "You can't vote more than once"
            else
                @problem_vote_solution = @problem_solution.problem_vote_solutions.create(user_id: current_user.id)
            end
            redirect_to problem_path(@problem)
            # respond_to do |format|
            #     format.html {}
            #     format.js
            # end
        else
            redirect_to login_path
        end
    end
    
    def destroy
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
        @problem_vote_solution = @problem_solution.problem_vote_solutions.find(params[:id])
        @problem_vote_solution.destroy
        redirect_to problem_path(@problem)
        # respond_to do |format|
        #     format.html {}
        #     format.js
        # end
    end

    def show
        @problem = Problem.friendly.find(params[:problem_id])
        @problem_solution = @problem.problem_solutions.friendly.find(params[:problem_solution_id])
        @problem_vote_solution = @problem_solution.problem_vote_solutions.find(params[:id])
    end

    private

    def problem_vote_solution_param
        # params.require(:problem_vote_solution).permit(:vote_content)
    end

    def already_voted?
        ProblemVoteSolution.where(user_id: current_user.id, problem_solution_id: params[:problem_solution_id]).exists?
    end

    def find_problem_solution
        @problem_solution = ProblemSolution.friendly.find(params[:problem_solution_id])
    end

    def find_vote
        @vote = @problem_solution.problem_vote_solutions.find(params[:id])
    end
end
