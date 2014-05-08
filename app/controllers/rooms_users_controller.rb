class RoomsUsersController < ApplicationController

  def create
    @room = Room.find(params[:room_id])
    if RoomsUser.where( user_id: current_user.id, room_id: @room.id ).first
      room_owner_login = @room.creator.login
      joined_user = User.find(params[:user_id])
      if !RoomsUser.create( room_id: @room.id, user_id: joined_user.id ).new_record?
        room_user_ids = RoomsUser.where( room_id: @room.id ).pluck(:user_id)
        @room_users = User.where( 'id IN (?)', room_user_ids )
        Pusher["private-#{params[:room_id]}"].trigger_async( 'add_user_to_room', { user_id: joined_user.id,
                                                                                   user_login: joined_user.login,
                                                                                   rooms_name: @room.name,
                                                                                   room_id: @room.id,
                                                                                   user_status: joined_user.user_status,
                                                                                   user_sign_out_time: joined_user.updated_at,
                                                                                   rooms_owner_id: @room.creator_id } )

        Pusher["private-#{params[:user_id]}"].trigger_async( 'user_add_to_room', { rooms_id: @room.id,
                                                                                   rooms_name: @room.name,
                                                                                   room_owner_id: @room.creator_id,
                                                                                   user_login: joined_user.login,
                                                                                   user_id: joined_user.id,
                                                                                   rooms_owner_login: room_owner_login,
                                                                                   room_members_count: @room_users.count } )
        #render :text => "Success"
      end
      render json: { joined_user: joined_user, room_id: @room.id, room_name: @room.name }
    end
  end

  def destroy
    room = Room.find( params[:room_id] ) if params[:room_id]
    user = User.find( params[:user_id] ) if params[:user_id]
    room_user = RoomsUser.where( user_id: params[:user_id], room_id: params[:room_id] ).first
    room_user.destroy
    Pusher["private-#{params[:room_id]}"].trigger_async( 'del_user_from_room', { user_login: user.login,
                                                                                 drop_user_id: params[:user_id],
                                                                                 room_name: room.name,
                                                                                 user_status: user.user_status,
                                                                                 room_id: params[:room_id] } )

    Pusher["private-#{params[:user_id]}"].trigger_async( 'private_del_user_from_room', { room_id: params[:room_id],
                                                                                         rooms_name: room.name } )
    render json: { drop_user_id: params[:user_id], user_login: user.login, room_name: room.name }
  end
end
