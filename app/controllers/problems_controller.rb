class ProblemsController < ApplicationController
    def index
        @problems = Problem.search(params[:search])
        @problem_all = Problem.all
        @problem_solutions = ProblemSolution.all
    end

    def new
        @problem = Problem.new
    end

    def create
        @problem = Problem.new(problem_param)

        if logged_in?
            @problem.user_name = @current_user.name
        else
            @problem.user_name = "Ẩn danh"
        end

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
        params.require(:problem).permit(:title, :problem_content, :difficult, :category, :search)
    end
end
