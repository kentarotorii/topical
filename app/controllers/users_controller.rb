class UsersController < ApplicationController
  def index
    @users = User.all
    @messages = Message.all
  end

  def show
    @user = User.find(params[:id])
    @followers = @user.followers
    @followed_users = @user.followed_users
  end
end
