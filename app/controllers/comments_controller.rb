class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @comment.author = find_user
    @comment.posts = find_post(:post_id)
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.posts = find_post(:post_id)

    if @comment.save
      flash[:notice] = 'Comment created successfully'
      puts 'success'
      redirect_to user_post_path(params[:user_id], params[:post_id])
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    # return render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false if @comment.nil?

    if @comment.destroy
      flash[:notice] = 'Comment deleted successfully'
    else
      flash[:alert] = 'Comment was not deleted something went wrong'
    end
    redirect_to user_post_path(params[:user_id], params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
