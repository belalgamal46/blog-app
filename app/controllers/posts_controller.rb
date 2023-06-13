class PostsController < ApplicationController
  def index
    @posts = Post.where(author_id: params[:user_id]).paginate(page: params[:page], per_page: 2)
    @user = User.find(params[:user_id])
  end

  def show
    @post = Post.find(params[:id])
  end
end
