class ProblemReplySolutionsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]

    def index 
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_reply_solutions = @problem_solution.problem_reply_solutions
    end

    def new
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_reply_solution = ProblemReplySolution.new
    end

    def create
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_reply_solution = @problem_solution.problem_reply_solutions.build(problem_reply_solution_param)

        if user_signed_in?
            @problem_reply_solution.user_name = current_user.name
            @problem_reply_solution.user_id = current_user.id
        end

        if @problem_reply_solution.save
            if(find_owner_user(@problem_solution).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@problem_solution), 
                                                            current_user, @problem.title, 
                                                            @problem_reply_solution.reply_content, 
                                                            problem_path(@problem, tab: 'ProblemSolutionID'), 
                                                            "ProblemSolutionComment")
            end
            
            # redirect_to problem_path(@problem, tab: 'ProblemSolutionID')
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = I18n.t(:create_error)
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_reply_solution = @problem_solution.problem_reply_solutions.find(params[:id])

        @problem_reply_solution.destroy
        redirect_to problem_path(@problem, tab: 'ProblemSolutionID')
    end

    def show
        @problem_solution = ProblemSolution.find(params[:problem_solution_id])
        @problem = @problem_solution.problem
        @problem_reply_solution = @problem_solution.problem_reply_solutions.find(params[:id])
    end

    private

    def problem_reply_solution_param
        params.require(:problem_reply_solution).permit(:reply_content)
    end
end
