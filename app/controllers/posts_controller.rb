class PostsController < ApplicationController
    def index
        @posts = Post.all
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_param)

        @post.username = @current_user.name

        if @post.save
            redirect_to post_path(@post)
        else
            flash[:danger] = "Bạn có muốn lưu lại bài viết không?"
            render :new
        end
    end

    # get current user ID
    def current_user
        @current_user ||= User.find_by id: session[:user_id]
    end

    def show
        @post = Post.find params[:id]
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
        redirect_to posts_path
    end

    private
    # define param for each post
    def post_param
        params.require(:post).permit(:username, :content, :title)
    end
end
