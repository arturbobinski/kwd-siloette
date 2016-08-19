class PostsController < ApplicationController

  def index
    @posts = Post.published.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @posts = Post.where.not(id: @post.id).limit(3).order("RAND()")
  end
end
