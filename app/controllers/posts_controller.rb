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

        @post.user_name = @current_user.name

        if @post.save
            redirect_to posts_path
        else
            flash[:danger] = "Hãy lưu lại thông tin của công ty"
            render :new
        end
    end

    def show
        @post = Post.find params[:id]
        @post_comment = PostComment.new
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
        params.require(:post).permit(:title, :content)
    end
end
