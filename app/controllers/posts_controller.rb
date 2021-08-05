class PostsController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]

    def index
        @posts = Post.all.order('created_at DESC').page(params[:page]).per(10)
        @post_comments = PostComment.all
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_param)
        
        if user_signed_in?
            @post.username = current_user.name
            @post.user_id = current_user.id
        end

        if @post.save
            redirect_to post_path(@post)
        else
            flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*'"
            render :new
        end
    end

    def show
        @post = Post.friendly.find(params[:id])
        @post_comments = @post.post_comments.order('created_at DESC').page(params[:page]).per(10)
        @posts = Post.all
    end

    def edit
        @is_edit = params[:is_edit]
        @post = Post.friendly.find params[:id]
    end

    def update
        @post = Post.friendly.find params[:id]

        if(@post.update(post_param))
            flash[:success] = "Update thông tin thành công"
            redirect_to post_path(@post)
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end
    end

    def destroy
        @post = Post.friendly.find params[:id]
        @post.destroy
        redirect_to posts_path
    end

    private
    
    def post_param
        params.require(:post).permit(:id, :wall_picture, :title, :content, :category)
    end
end
