class PostCommentsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index 
        @post = Post.friendly.find(params[:post_id])
        @post_comments = @post.post_comments
    end

    def new
        @post = Post.friendly.find(params[:post_id])
        @post_comment = PostComment.new
    end

    def create
        @post = Post.friendly.find(params[:post_id])
        @post_comment = @post.post_comments.build(post_comment_param)

        if user_signed_in?
            @post_comment.user_name = current_user.name
            @post_comment.user_id = current_user.id
        end

        if @post_comment.save
            # redirect_to post_path(@post)
            respond_to do |format|
                format.html {}
                format.js
            end
        else
            flash[:danger] = I18n.t(:create_error)
            render :new
        end
    end

    def edit
    end

    def update
    end
    
    def destroy
        @post = Post.friendly.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:id])
        @post_comment.destroy
        
        redirect_to post_path(@post)
    end

    def show
        @post = Post.friendly.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:id])
    end

    private

    def post_comment_param
        params.require(:post_comment).permit( :comment_content)
    end
end
