class PostsController < ApplicationController
    def index
        @posts = Post.all
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

        if @post.save
            redirect_to posts_path
        else
            flash[:danger] = "[WARN]Can't save data"
            render :new
        end
    end

    def show
        @post = Post.find params[:id]
        @post_comment = PostComment.new
        @posts = Post.all
    end

    def edit
        @post = Post.find params[:id]
    end

    def update
        @post = Post.find params[:id]
    end

    def destroy
        @post = Post.find params[:id]
        @post.destroy
        redirect_to post_path
    end

    private
    # define param for each post
    def post_param
        params.require(:post).permit(:wall_picture, :title, :content)
    end
end
