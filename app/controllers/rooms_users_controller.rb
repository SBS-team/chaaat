class RoomsUsersController < ApplicationController

  def create
    if RoomsUser.where(:user_id => current_user.id, :room_id=>params[:room_id]).first
      @room = Room.find(params[:room_id])
      if RoomsUser.create(:room_id=>params[:room_id], :user_id => params[:user_id]).valid?
        joined_user = User.find(params[:user_id])
        room_user_ids = RoomsUser.where(:room_id => @room.id).pluck(:user_id)
        @room_users = User.where("id IN (?)", room_user_ids)
        Pusher["private-#{params[:room_id]}"].trigger('add_user_to_room', {:user_id=>joined_user.id,:user_login=>joined_user.login,:rooms_name=>@room.name, :room_id=>@room.id})
        Pusher["private-#{params[:user_id]}"].trigger('user_add_to_room', {:rooms_id=>@room.id,:rooms_name=>@room.name})
      else
        flash[:error] = "User already in room"
      end
      render json: {:joined_user => joined_user, :room_id => @room.id}
  end
  end

  def destroy
    room_user = RoomsUser.where("user_id = ? AND room_id = ?", params[:user_id], params[:room_id]).first
    room_users_count = RoomsUser.where("room_id = ?", params[:room_id]).count
    if(current_user.id == params[:user_id].to_i)
      room_user.destroy
      if (room_users_count -= 1).zero?
        room = Room.find(params[:room_id])
        room.destroy
      end
    end
    render json: {:drop_user_id => params[:user_id], :cur_user_id => current_user.id}
  end

end

