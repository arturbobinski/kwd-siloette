module System
  class PostsController < System::BaseController

    skip_before_filter :authenticate_user!
    
    def index
      @posts = Post.published.page(params[:page])
    end

    def show
    end
  end
end