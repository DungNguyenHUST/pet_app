class PostsController < ApplicationController
    include ApplicationHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]

    def index
        add_breadcrumb I18n.t(:home_page), :root_path
        add_breadcrumb I18n.t(:all_post), :posts_path

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
            flash[:danger] = I18n.t(:create_error)
            render :new
        end
    end

    def show
        @post = Post.friendly.find(params[:id])
        @post_comments = @post.post_comments.order('created_at DESC').page(params[:page]).per(10)

        @post_relateds = Post.all.order('created_at DESC').reject{|i| i.id == @post.id}
        
        add_breadcrumb I18n.t(:home_page), :root_path
        add_breadcrumb I18n.t(:all_post), :posts_path
        add_breadcrumb @post.title, post_path(@post)
    end

    def edit
        @is_edit = params[:is_edit]
        @post = Post.friendly.find params[:id]
    end

    def update
        @post = Post.friendly.find params[:id]

        if(@post.update(post_param))
            flash[:success] = I18n.t(:update_success)
            redirect_to post_path(@post)
        else
            flash[:danger] = I18n.t(:update_error)
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
