class ProblemsController < ApplicationController
    def index
        @problems = Problem.all
        @problem_solutions = ProblemSolution.all
    end

    def new
        @problem = Problem.new
    end

    def create
        @problem = Problem.new(problem_param)

        @problem.user_name = @current_user.name

        if @problem.save
            redirect_to problems_path
        else
            flash[:danger] = "Hãy lưu lại thông tin của công ty"
            render :new
        end
    end

    def show
        @problem = Problem.find params[:id]
        @problem_solution = ProblemSolution.new
    end

    def edit
        @problem = Problem.find params[:id]
    end

    def update
        @problem = Problem.find params[:id]
    end

    def destroy
        @problem = Problem.find params[:id]
        @problem.destroy
        redirect_to problem_path
    end

    private
    # define param for each problem
    def problem_param
        params.require(:problem).permit(:title, :content, :difficult)
    end
end
