class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.includes(:comments).paginate(page: params[:page], per_page: 2)
  end

  def show
    find_post(:id)
    find_user
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = find_user
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
