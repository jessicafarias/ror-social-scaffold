class FriendshipsController < ApplicationController 
  def create
    #@friendship = Friendship.new(friend_id: params[:id], user_id: current_user.id)
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to users_path, notice: 'Friendship request sended!' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to users_path, alert: "EROOR wehe#{a}" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end
end
