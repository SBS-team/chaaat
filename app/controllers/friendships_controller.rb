class FriendshipsController < ApplicationController

  def create
    friendship = current_user.friendships.build(:friend_id => friendship_params[:friend_id]) #FIXME check what happenes when we got wrong id
    added_friend = friendship.friend
    inverse_friendship = added_friend.friendships.build(:friend_id => current_user.id)
    if friendship.save && inverse_friendship.save
      flash[:notice] = 'User confirmed that you are friends'
    else
      flash[:error] = 'User rejected your friendship'
    end
    #redirect_to user_path(current_user.id)
    render :json => friendship_params[:friend_id]
  end

  def destroy
    friendship = current_user.friendships.where(:friend_id => params[:friend_id]).first #FIXME refactoring
    inverse_friendship = Friendship.find_by(:user_id => friendship.friend.id, :friend_id => current_user.id) #FIXME refactoring
    friendship.destroy
    inverse_friendship.destroy
    render :json => params[:friend_id]
  end

private

  def friendship_params
    params.permit(:user_id, :friend_id)
  end

end
