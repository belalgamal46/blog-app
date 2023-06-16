class ApplicationController < ActionController::Base
  def current_user
    @user = User.first
  end

  def find_user(user)
    @user = User.find(params[user])
  end

  def find_post(post)
    @post = Post.find(params[post])
  end
end
