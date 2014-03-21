class RoomsUsersController < ApplicationController

  def create
    if RoomsUser.where(:user_id => current_user.id).last
      @room = Room.find(params[:room_id])
      if RoomsUser.create(:room_id=>params[:room_id], :user_id => params[:user_id]).valid?
        joined_user = User.where(:id => params[:user_id]).first
        room_user_ids = RoomsUser.where(:room_id => @room.id).pluck(:user_id)
        @room_users = User.where("id IN (?)", room_user_ids)
      else
        flash[:error] = "User already in room"
      end

      render json: {:joined_user => joined_user, :room_id => @room.id}
  end
  end

  def destroy
    room_user = RoomsUser.where("user_id = ? AND room_id = ?", params[:user_id], params[:room_id]).first
    room_users_count = RoomsUser.where("room_id = ?", room_user.room_id).count
    if(current_user.id == params[:user_id].to_i)
      room_user.destroy
      if (room_users_count -= 1).zero?
        room = Room.find(params[:room_id])
        room.destroy
        #change redirect to main page
        redirect_to root_path
      end
    else
      render json: {:drop_user_id => params[:user_id], :cur_user_id => current_user.id}
    end

    #redirect_to room_path(params[:room_id])
  end

end


