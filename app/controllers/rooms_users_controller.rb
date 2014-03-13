class RoomsUsersController < ApplicationController
  def create
    @room = Room.find(params[:id])
    @rooms_user = RoomsUser.create(:room_id=> @room.id, :user_id => params[:user_id])
    render :text => params
    redirect_to room_path(@room)
  end
end
