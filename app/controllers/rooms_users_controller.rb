class RoomsUsersController < ApplicationController

  def create #FIXME refactoring
    @room = Room.find(params[:room_id])
    if RoomsUser.where(:user_id => current_user.id, :room_id=>@room.id).first
      joined_user = User.find(params[:user_id])
      if !RoomsUser.create(:room_id=>@room.id, :user_id=>joined_user.id).new_record?
        Pusher["private-#{params[:room_id]}"].trigger_async('add_user_to_room', {:user_id => joined_user.id,
                                                                           :user_login => joined_user.login,
                                                                           :rooms_name => @room.name,
                                                                           :room_id => @room.id,
                                                                           :user_status => joined_user.user_status,
                                                                           :user_sign_out_time=>joined_user.updated_at})
        Pusher["private-#{params[:user_id]}"].trigger_async('user_add_to_room', {:rooms_id=>@room.id,:rooms_name=>@room.name})
        render :text => "Success"
      end
    end
  end

  def destroy
    room_user = RoomsUser.where("user_id = ? AND room_id = ?", params[:user_id], params[:room_id]).first
    room_users_count = RoomsUser.where("room_id = ?", params[:room_id]).count
    if(current_user.id == params[:user_id].to_i)
      room_user.destroy
      Pusher["private-#{params[:room_id]}"].trigger_async('del_user_from_room', {:user_login => current_user.login,
                                                                           :drop_user_id => params[:user_id],
                                                                           :cur_user_id => current_user.id})
      if (room_users_count -= 1).zero? #FIXME wat?
        room = Room.find(params[:room_id])
        room.destroy
      end
    end
    render json: {:drop_user_id => params[:user_id], :cur_user_id => current_user.id}
  end


end

