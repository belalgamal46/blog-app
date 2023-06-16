class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    find_user(:id)
  end
end
