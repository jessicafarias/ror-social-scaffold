class FriendshipsController < ApplicationController
  before_action :find_user, only: %i[update destroy]

  def create
    @friendship = current_user.sent_requests.build(friend_id: params[:friend_id])
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
    respond_to do |format|
      if current_user.confirm_friend(@user)
        format.html { redirect_to users_path, notice: 'Friendship Confirmed.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to users_path, alert: 'Error' }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user.delete_friend(@user)
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
