class PostsController < ApplicationController
  def index
    @posts = Post.includes(:author).where(id: params[:user_id]).paginate(page: params[:page], per_page: 2)
    @user = User.find(params[:user_id])
  end

  def show
    find_post(:id)
    find_user(:user_id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = find_user(:user_id)
    if @post.save
      flash[:notice] = 'Your post was created successfully'
      redirect_to user_post_path(@post.author, @post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
