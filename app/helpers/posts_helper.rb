module PostsHelper
    # get current post id
    def current_post
        @current_post ||= Post.friendly.find(params[:id])
    end
end
