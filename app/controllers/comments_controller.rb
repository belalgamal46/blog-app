class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @comment.author = find_user(:user_id)
    @comment.posts = find_post(:post_id)
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author = find_user(:user_id)
    @comment.posts = find_post(:post_id)

    if @comment.save
      flash[:notice] = 'Comment created successfully'
      puts 'success'
      redirect_to user_post_path(params[:user_id], params[:post_id])
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
