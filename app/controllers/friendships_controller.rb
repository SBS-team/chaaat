class FriendshipsController < ApplicationController

  def create
    friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    added_friend = friendship.friend
    inverse_friendship = added_friend.friendships.build(:friend_id => current_user.id)

    if friendship.save && inverse_friendship.save
      flash[:notice] = 'User confirmed that you are friends'
      redirect_to user_path(current_user.id)
    else
      flash[:error] = 'User rejected your friendship'
    end
  end

  def destroy
    friendship = current_user.friendships.find(params[:id])
    inverse_friendship = Friendship.find_by_user_id_and_friend_id(friendship.friend.id, current_user.id)
    friendship.destroy
    inverse_friendship.destroy
    flash[:notice] = 'Friendship is over'
    redirect_to current_user
  end

end
