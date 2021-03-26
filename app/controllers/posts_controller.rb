class PostsController < ApplicationController
    def index
        @posts = Post.all.approved
        @post_comments = PostComment.all
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_param)

        if logged_in?
            @post.username = @current_user.name
        else
            @post.username = "Ẩn danh"
        end

        if @post.save!
			@post.wall_picture.attach(params[:post][:wall_picture])
            if @post.approved?
				redirect_to post_path(@post)
			else
				flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
				redirect_to posts_path
			end
        else
            flash[:danger] = "[WARN]Can't save data"
            render :new
        end
    end

    def show
        @post = Post.friendly.find(params[:id])
        @post_comment = PostComment.new
        @posts = Post.all
    end

    def edit
        @post = Post.friendly.find params[:id]
    end

    def update
        @post = Post.friendly.find params[:id]
		if @post.update_column(:approved, true)
			flash[:success] = "Approved"
			redirect_to pages_path
		else
			if(@post.update(post_param))
				if @post.approved?
					redirect_to post_path(@post)
				else
					flash[:success] = "Thông tin của bạn đã được tiếp nhận, vui lòng chờ quản trị viên sẽ xử lý trong 30min - 1h"
					redirect_to posts_path
				end
			else
				flash[:danger] = "Không thể cập nhật thông tin"
			end
		end
    end

    def destroy
        @post = Post.friendly.find params[:id]
        @post.destroy
        redirect_to pages_path
    end

    private
    # define param for each post
    def post_param
        params.require(:post).permit(:id, :title, :content_rich_text)
    end
end
