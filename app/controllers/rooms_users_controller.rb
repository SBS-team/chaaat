class RoomsUsersController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    if !RoomsUser.exists?(:user_id => params[:user_id])
      RoomsUser.create(:room_id=>params[:room_id], :user_id => params[:user_id])
    else
      flash[:error] = "User already in room"
    end
    redirect_to room_path(@room)
  end

  def destroy
    room_user = RoomsUser.where("user_id = ? AND room_id = ?", params[:user_id], params[:id]).first
    room_users_count = RoomsUser.where("room_id = ?", room_user.room_id).count
    room_user.destroy
    if (room_users_count -= 1).zero?
      room = Room.find(params[:id])
      room.destroy
      render :text => "There are no more rooms"
    else
      redirect_to room_path(params[:id])
    end
  end

end
