class FriendshipsController < ApplicationController

  def create
    current_user.friendships.create( friend_id: friendship_params[:friend_id] )
    render json: friendship_params[:friend_id]
  end

  def destroy
    Friendship.find_and_destroy( params[:friend_id], current_user.id )
    render json: params[:friend_id]
  end

  private

  def friendship_params
    params.permit( :user_id, :friend_id )
  end

end