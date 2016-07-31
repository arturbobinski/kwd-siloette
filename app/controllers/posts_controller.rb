class PostsController < ApplicationController

  def index
    @posts = Post.published.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end
end
