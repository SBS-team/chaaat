class FriendshipsController < ApplicationController
  include UsersHelper

  def create
    if User.where(:id => friendship_params[:friend_id]).first != nil
      if !is_friend? friendship_params[:friend_id]
        friendship = current_user.friendships.build(:friend_id => friendship_params[:friend_id])
        added_friend = friendship.friend
        inverse_friendship = added_friend.friendships.build(:friend_id => current_user.id)
        friendship.save
        inverse_friendship.save
        render :json => friendship_params[:friend_id]
      end
    end
  end

  def destroy
    friendship = current_user.friendships.where(:friend_id => params[:friend_id]).first
    inverse_friendship = friendship.friend.friendships.where(:friend_id => current_user.id).first
    friendship.destroy
    inverse_friendship.destroy
    render :json => params[:friend_id]
  end

  private
  def friendship_params
    params.permit(:user_id, :friend_id)
  end

end