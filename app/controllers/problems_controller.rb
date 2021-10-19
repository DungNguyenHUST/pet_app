class ProblemsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    before_action :require_admin_login, only: [:approve]

    def index
        # Auto complete
        @suggest_problems = Problem.search_problem_by_title(params[:search])
        respond_to do |format|
            format.html {}
            format.json {
                @suggest_problems = @suggest_problems.limit(10)
            }
        end

        # Search
        @is_problem_searched = false
		if(params.has_key?(:search))
            @is_problem_searched = true
			@problem_searchs = Problem.search_problem_by_title(params[:search]).order("created_at DESC").approved.page(params[:page]).per(12)
        end

		@problems_all = Problem.all.order("id ASC").approved.page(params[:page]).per(20)
        @problems_newest = Problem.all.order("created_at DESC").approved
        @problem_math = Problem.where(:category => "1").order("id ASC").approved.page(params[:page]).per(20)
        @problem_eq_test = Problem.where(:category => "2").order("id ASC").approved.page(params[:page]).per(20)
        @problem_iq_test = Problem.where(:category => "3").order("id ASC").approved.page(params[:page]).per(20)
        @problem_interview = Problem.where(:category => "4").order("id ASC").approved.page(params[:page]).per(20)
        @problem_other = Problem.where(:category => "5").order("id ASC").approved.page(params[:page]).per(20)

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end
    end

    def new
        @problem = Problem.new
    end

    def create
        @problem = Problem.new(problem_param)

        if user_signed_in?
            @problem.user_name = current_user.name
            @problem.user_id = current_user.id
        end

        if admin_signed_in?
            @problem.approved = true
        end

        if @problem.save!
            if @problem.approved?
				redirect_to problem_path(@problem)
			else
				flash[:success] = "Để đảm bảo chất lượng thông tin, câu hỏi của bạn đang được xếp vào hàng chờ duyệt. Vui lòng kiểm tra lại sau ít phút..."
				redirect_to problems_path
			end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            render :new
        end
    end

    def show
        @problem = Problem.friendly.find params[:id]
        @problems = Problem.all.approved.page(params[:page]).per(20)
        @problem_solutions = @problem.problem_solutions.page(params[:page]).per(10)
        
        @problem_solutions_best = []
        count = 1
        @problem_solutions.each do |problem_solution|
            temp_count = problem_solution.problem_react_solutions.where(:react_type => 1).count - problem_solution.problem_react_solutions.where(:react_type => 0).count
            if temp_count >= count
                count = temp_count
                @problem_solutions_best = problem_solution
            end
        end

        @problem_submition = []
        @problem.problem_solutions.each do |problem_solution|
            if current_user.present?
                if problem_solution.user_id == current_user.id
                    @problem_submition.push(problem_solution)
                end
            end
        end

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
        end

        @problem_relateds = Problem.all.approved.reject{|i| i.id == @problem.id}
        @problem_relateds = Kaminari.paginate_array(@problem_relateds).page(params[:page]).per(20)
    end

    def edit
        @is_edit = params[:is_edit]
        @problem = Problem.friendly.find params[:id]
    end

    def update
        @problem = Problem.friendly.find params[:id]

        if(@problem.update(problem_param))
            redirect_to problem_path(@problem)
            flash[:success] = "Update thông tin thành công"
        else
            flash[:danger] = "Lỗi, không thể update thông tin"
        end
    end

    def approve
        @problem = Problem.friendly.find(params[:id])
        if @problem.update(:approved => true)
            flash[:success] = "Approved"
        else
            flash[:danger] = "Error"
        end
        redirect_to admin_path(current_admin, tab: 'AdminProblemApprovingID')
    end

    def destroy
        @problem = Problem.friendly.find params[:id]
        @problem.destroy
        redirect_to admin_path(current_admin, tab: 'AdminProblemID')
    end

    private
    
    def problem_param
        params.require(:problem).permit(:id, :title, :content, :difficult, :category, :search)
    end
end
