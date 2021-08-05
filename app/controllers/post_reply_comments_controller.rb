class PostReplyCommentsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]

    def index 
        @post_comment = PostComment.find(params[:post_comment_id])
        @post = @post_comment.post
        @post_reply_comments = @post_comment.post_reply_comments
    end

    def new
        @post_comment = PostComment.find(params[:post_comment_id])
        @post = @post_comment.post
        @post_reply_comment = PostReplyComment.new
    end

    def create
        @post_comment = PostComment.find(params[:post_comment_id])
        @post = @post_comment.post
        @post_reply_comment = @post_comment.post_reply_comments.build(post_reply_comment_param)

        if user_signed_in?
            @post_reply_comment.user_name = current_user.name
            @post_reply_comment.user_id = current_user.id
        end

        if @post_reply_comment.save
            if(find_owner_user(@post_comment).present?)
                UserNotificationsController.new.create_notify(find_owner_user(@post_comment), 
                                                                current_user, 
                                                                @post.title, 
                                                                @post_reply_comment.reply_content, 
                                                                post_path(@post), 
                                                                "PostComment")
            end
            
            # redirect_to post_path(@post)
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            # render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @post_comment = PostComment.find(params[:post_comment_id])
        @post = @post_comment.post
        @post_reply_comment = @post_comment.post_reply_comments.find(params[:id])

        @post_reply_comment.destroy
        redirect_to post_path(@post)
    end

    def show
        @post_comment = PostComment.find(params[:post_comment_id])
        @post = @post_comment.post
        @post_reply_comment = @post_comment.post_reply_comments.find(params[:id])
    end

    private

    def post_reply_comment_param
        params.require(:post_reply_comment).permit(:reply_content)
    end
end
