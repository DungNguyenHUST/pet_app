class ProblemsController < ApplicationController
    def index
        @problems = Problem.search(params[:search]).order("created_at DESC").reverse
        @problems_newest = Problem.all.order("created_at DESC")
        @problem_solutions = ProblemSolution.all

        @problem_math = []
        @problem_eq_test = []
        @problem_iq_test = []
        @problem_interview = []
        @problem_other = []

        @problems.each do |problem|
            if(problem.category.to_i == 1 || problem.category.to_s == 'Thuật toán')
                @problem_math.push(problem)
            elsif(problem.category.to_i == 2 || problem.category.to_s == 'Câu hỏi phỏng vấn')
                @problem_interview.push(problem)
            elsif(problem.category.to_i == 3 || problem.category.to_s == 'EQ Test')
                @problem_eq_test.push(problem)
            elsif(problem.category.to_i == 4 || problem.category.to_s == 'IQ Test')
                @problem_iq_test.push(problem)
            elsif(problem.category.to_i == 5 || problem.category.to_s == 'Câu hỏi khác')
                @problem_other.push(problem)
            end 
        end
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
        @problems = Problem.all
    end

    def edit
        @problem = Problem.find params[:id]
    end

    def update
        @problem = Problem.find params[:id]
        if(@problem.update(problem_param))
            redirect_to problems_path
        else
            flash[:danger] = "Không thể cập nhật thông tin"
        end
    end

    def destroy
        @problem = Problem.find params[:id]
        @problem.destroy
        redirect_to pages_path
    end

    private
    # define param for each problem
    def problem_param
        params.require(:problem).permit(:id, :title, :content_rich_text, :difficult, :category, :search)
    end
end
