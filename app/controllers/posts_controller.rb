class PostsController < ApplicationController
  def index
    @user = current_user
    @posts = @user.posts.includes(:comments).paginate(page: params[:page], per_page: 2)
    puts @posts
  end

  def show
    @post = find_post(:id)
    @user = current_user
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    if @post.save
      flash[:notice] = 'Your post was created successfully'
      redirect_to user_post_path(@post.author, @post)
    else
      render :new, status: :unprocessable_entity
      flash[:notice] = 'something went wrong'
    end
  end

  def destroy
    @post = Post.find_by(author_id: params[:user_id], id: params[:id])

    if @post.destroy
      redirect_to user_posts_path(current_user)
      flash[:notice] = 'Your post have been deleted successfully'
    else
      redirect_to user_post_path(current_user, @post)
      flash[:alert] = 'The post is not deleted something went wrong'
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
