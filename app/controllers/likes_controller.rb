class LikesController < ApplicationController
  def create
    @like = Like.new
    @like.author = find_user
    @like.posts = find_post(:post_id)

    if @like.save
      redirect_to user_post_path(params[:user_id], params[:post_id])
    else
      render user_post_path(params[:user_id], params[:post_id]), status: :unprocessable_entity
    end
  end
end
