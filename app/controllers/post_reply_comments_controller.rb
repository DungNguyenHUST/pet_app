class PostReplyCommentsController < ApplicationController
    def index 
        @post = Post.find(params[:post_id])
        @post_comments = @post.post_comments
        @post_reply_comments = @post_comments.post_reply_comments
    end

    def new
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:post_comment_id])
        @post_reply_comment = PostReplyComment.new
    end

    def create
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:post_comment_id])
        @post_reply_comment = @post_comment.post_reply_comments.build(post_reply_comment_param)

        @post_reply_comment.user_name = @current_user.name

        if @post_reply_comment.save
            redirect_to post_path(@post)
        else
            flash[:danger] = "Lỗi, Không thể trả lời *?"
            # render :new
        end
    end
    
    def destroy
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:post_comment_id])
        @post_reply_comment = @post_comment.post_reply_comments.find(params[:id])

        @post_reply_comment.destroy
        redirect_to post_path(@post)
    end

    def show
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:post_comment_id])
        @post_reply_comment = @post_comment.post_reply_comments.find(params[:id])
    end

    private

    def post_reply_comment_param
        params.require(:post_reply_comment).permit(:reply_content)
    end
end
