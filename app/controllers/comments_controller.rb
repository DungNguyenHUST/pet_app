class CommentsController < ApplicationController

    def index 
        @comment = Comment.new
        @post = Post.find(params[:post_id])
    end

    def new
        @comment = Comment.new
    end

    def create
        @post = Post.find(params[:post_id])

        @comment = @post.comments.build(commment_param)
        # @comment = Comment.new(commment_param)

        @comment.username = @current_user.name

        if @comment.save
            flash[:success] = "Đã lưu lại comment"
            redirect_to post_path(@post)
        else
            flash[:danger] = "Comment lỗi?"
            # render :new
        end
    end
  
    def destroy
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        @comment.destroy
        redirect_to post_path(@post)
    end

    def show
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
    end

    private

    def commment_param
        params.require(:comment).permit(:username, :comment)
    end
end
