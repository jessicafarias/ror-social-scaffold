class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    return @users = User.where.not(id: current_user.id) unless current_user.nil?

    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end
