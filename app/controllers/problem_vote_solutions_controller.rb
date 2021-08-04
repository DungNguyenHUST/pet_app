class ProblemVoteSolutionsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    before_action :find_problem_solution
    before_action :find_vote, only: [:destroy]
    
    def index 
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_vote_solutions = @problem_solution.problem_vote_solutions
    end

    def new
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_vote_solution = ProblemVoteSolution.new
    end

    def create
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        if already_voted?
            # flash[:notice] = "You can't vote more than once"
        else
            @problem_vote_solution = @problem_solution.problem_vote_solutions.create(user_id: current_user.id)
        end
        # redirect_to problem_path(@problem)
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
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_vote_solution = @problem_solution.problem_vote_solutions.find(params[:id])
        @problem_vote_solution.destroy
        # redirect_to problem_path(@problem)
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def show
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_vote_solution = @problem_solution.problem_vote_solutions.find(params[:id])
    end

    private

    def already_voted?
        ProblemVoteSolution.where(user_id: current_user.id, problem_solution_id: params[:problem_solution_id]).exists?
    end

    def find_problem_solution
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
    end

    def find_vote
        @vote = @problem_solution.problem_vote_solutions.find(params[:id])
    end
end
