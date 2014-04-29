class FriendshipsController < ApplicationController

  def create
    friendship = current_user.friendships.create(:friend_id => friendship_params[:friend_id])
    friendship = friendship.friend.friendships.create(:friend_id => current_user.id)
    render :json => friendship_params[:friend_id]
  end

  def destroy
    friendship = Friendship.where('(friend_id = ? AND user_id = ?) OR (friend_id = ? AND user_id = ?)', params[:friend_id], current_user.id, current_user.id, params[:friend_id]).destroy_all
    render :json => params[:friend_id]
  end
  private

  def friendship_params
    params.permit(:user_id, :friend_id)
  end

end