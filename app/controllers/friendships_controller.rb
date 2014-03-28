class FriendshipsController < ApplicationController

  def create
    friendship = current_user.friendships.build(:friend_id => friendship_params[:friend_id])
    added_friend = friendship.friend
    inverse_friendship = added_friend.friendships.build(:friend_id => current_user.id)

    if friendship.save && inverse_friendship.save
      flash[:notice] = 'User confirmed that you are friends'
      #redirect_to user_path(current_user.id)
    else
      flash[:error] = 'User rejected your friendship'
    end
    #redirect_to user_path(current_user.id)
    render :json => friendship_params[:friend_id]
  end

  def destroy
    friendship = current_user.friendships.where(:friend_id => params[:friend_id]).first
    inverse_friendship = Friendship.find_by(:user_id => friendship.friend.id, :friend_id => current_user.id)
    friendship.destroy
    inverse_friendship.destroy
    flash[:notice] = 'Friendship is over'
    render :json => params[:friend_id]
  end

private
  def friendship_params
    params.permit(:user_id, :friend_id)
  end

end
