class FriendshipsController < ApplicationController
  before_action :find_user, only: %i[update destroy]

  def create
    # Creates Friendship Row
    # User sends Friend Request
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to users_path, notice: 'Friendship request sent!' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to users_path, alert: 'Error' }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @friendship = current_user.confirm_friend(@user)
    @friendship.confirmed = true
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to users_path, notice: 'Friendship Confirmed.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to users_path, alert: 'Error' }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @friendship = current_user.delete_friend(@user)
    respond_to do |format|
      if @friendship.destroy
        format.html { redirect_to users_path, notice: 'Friendship Successfully Deleted.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to users_path, alert: 'Error' }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_user
    @user = User.find(params[:id])
  end
end
