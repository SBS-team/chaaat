class FriendshipsController < ApplicationController

  def create
    friendship = current_user.friendships.build(:friend_id => friendship_params[:friend_id])
    added_friend = friendship.friend
    inverse_friendship = added_friend.friendships.build(:friend_id => current_user.id)
    friendship.save
    inverse_friendship.save

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