class PostsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    def index
        @posts = Post.all.approved
        @post_comments = PostComment.all
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_param)
        @post.username = current_user.name
        @post.user_id = current_user.id

        if current_user.admin?
            @post.approved = true
            @post.save!
            redirect_to pages_path(tab_id: 'AdminPostID')
            return
        end

        if @post.save
            if @post.approved?
				redirect_to post_path(@post)
			else
				flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
				redirect_to posts_path
			end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            render :new
        end
    end

    def show
        @post = Post.friendly.find(params[:id])
        @post_comment = PostComment.new
        @posts = Post.all
    end

    def edit
        @is_edit = params[:is_edit]
        @post = Post.friendly.find params[:id]
    end

    def update
        @post = Post.friendly.find params[:id]

        if post_param.present? && !(post_param.has_key?(:approved))
			if(@post.update(post_param))
				if @post.approved?
					redirect_to post_path(@post)
				else
					flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
					redirect_to posts_path
				end
			else
				flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
			end
        else
            if (!@post.approved? && @post.update_column(:approved, true))
                flash[:success] = "Approved"
                redirect_to pages_path(tab_id: 'PostID')
            elsif (@post.approved? && @post.update_column(:approved, false))
                flash[:danger] = "Rejected"
                redirect_to pages_path(tab_id: 'PostID')
            end
        end
    end

    def destroy
        @post = Post.friendly.find params[:id]
        @post.destroy
        redirect_to pages_path(tab_id: 'PostID')
    end

    private
    # define param for each post
    def post_param
        params.require(:post).permit(:id, :wall_picture, :title, :content, :category)
    end
end
