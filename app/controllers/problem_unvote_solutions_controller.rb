class ProblemUnvoteSolutionsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_unvote_solutions = @problem_solution.problem_unvote_solutions
    end

    def new
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_unvote_solution = ProblemUnvoteSolution.new
    end

    def create
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem

        if !already_unvoted?
            @problem_unvote_solution = @problem_solution.problem_unvote_solutions.create(user_id: current_user.id)
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
        @problem_unvote_solution = @problem_solution.problem_unvote_solutions.find(params[:id])
        @problem_unvote_solution.destroy

        # redirect_to problem_path(@problem)
        respond_to do |format|
            format.html {redirect_to :back}
            format.js
        end
    end

    def show
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_unvote_solution = @problem_solution.problem_unvote_solutions.find(params[:id])
    end

    private

    def already_unvoted?
        ProblemUnvoteSolution.where(user_id: current_user.id, problem_solution_id: params[:problem_solution_id]).exists?
    end
end
