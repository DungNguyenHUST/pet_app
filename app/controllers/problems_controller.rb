class ProblemsController < ApplicationController
    def index
        @is_problem_searched = false
		if(params.has_key?(:search))
            @is_problem_searched = true
			@problem_searchs = Problem.friendly.search(params[:search]).order("created_at DESC").approved.reverse
        end
		@problems_all = Problem.all.approved
        @problems_newest = Problem.all.order("created_at DESC").approved
        @problem_solutions = ProblemSolution.all

        @problem_math = []
        @problem_eq_test = []
        @problem_iq_test = []
        @problem_interview = []
        @problem_other = []

        @problems_all.each do |problem|
			if problem.category?
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

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
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

        if @problem.save!
            if @problem.approved?
				redirect_to problem_path(@problem)
			else
				flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
				redirect_to problems_path
			end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            render :new
        end
    end

    def show
        @problem = Problem.friendly.find params[:id]
        @problems = Problem.all
        @problem_solutions = @problem.problem_solutions
        
        @problem_solutions_best = []
        count = 0
        @problem_solutions.each do |problem_solution|
            if problem_solution.problem_vote_solutions.count - problem_solution.problem_unvote_solutions.count >= count
                count = problem_solution.problem_vote_solutions.count - problem_solution.problem_unvote_solutions.count
                @problem_solutions_best = problem_solution
            end
        end

        @problem_submition = []
        @problem_solutions.each do |problem_solution|
            if logged_in?
                if problem_solution.user_id == current_user.id
                    @problem_submition.push(problem_solution)
                end
            end
        end

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end
    end

    def edit
        @problem = Problem.friendly.find params[:id]
    end

    def update
        @problem = Problem.friendly.find params[:id]

        if problem_param.present? && !(problem_param.has_key?(:approved))
            if(@problem.update(problem_param))
				if @problem.approved?
					redirect_to problem_path(@problem)
				else
					flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
					redirect_to problems_path
				end
			else
				flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
			end
        else
            if (!@problem.approved? && @problem.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to pages_path(tab_id: 'ProblemID')
            elsif (@problem.approved? && @problem.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to pages_path(tab_id: 'ProblemID')
            end
        end
    end

    def destroy
        @problem = Problem.friendly.find params[:id]
        @problem.destroy
        redirect_to pages_path(tab_id: 'ProblemID')
    end

    private
    # define param for each problem
    def problem_param
        params.require(:problem).permit(:id, :title, :content, :difficult, :category, :search)
    end
end
