class ProblemReactSolutionsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem_react_solutions = @problem_solution.problem_react_solutions
    end

    def new
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem_react_solution = ProblemReactSolution.new
    end

    def create
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])

        @react = @problem_solution.problem_react_solutions.find { |react| (react.user_id == current_user.id) && (react.react_type == 0 || react.react_type == 1)}

        unless @react.nil?
            @react.update(react_type: params[:react_type])
        else
            # Created reactd
            @problem_react_solution = @problem_solution.problem_react_solutions.build(user_id: current_user.id, react_type: params[:react_type])
            @problem_react_solution.save!
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
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem_react_solution = @problem_solution.problem_react_solutions.find(params[:id])
        @problem_react_solution.destroy
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
