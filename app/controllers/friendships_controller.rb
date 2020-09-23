class FriendshipsController < ApplicationController 
  def create
    # Creates Friendship Row
    # User sends Friend Request
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to users_path, notice: 'Friendship request sent!' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to users_path, alert: "EROOR wehe#{a}" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept(user)
    @accepted = current_user.confirm_friend(user)
    respond_to do |format|
        format.html { redirect_to users_path, notice: 'Friendship request sent!' }
        format.json { render :show, status: :created, location: @accepted }
    end
  end
end
