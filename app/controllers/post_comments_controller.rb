class PostCommentsController < ApplicationController
    def index 
        @post = Post.find(params[:post_id])
        @post_comments = @post.post_comments
    end

    def new
        @post = Post.find(params[:post_id])
        @post_comment = PostComment.new
    end

    def create
        @post = Post.find(params[:post_id])

        @post_comment = @post.post_comments.build(post_comment_param)

        @post_comment.user_name = @current_user.name

        if @post_comment.save
            redirect_to post_path(@post)
        else
            flash[:danger] = "Comment lỗi?"
            render :new
        end
    end
    
    def destroy
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:id])
        @post_comment.destroy
        redirect_to post_path(@post)
    end

    def show
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:id])
    end

    private

    def post_comment_param
        params.require(:post_comment).permit( :comment_content)
    end
end
