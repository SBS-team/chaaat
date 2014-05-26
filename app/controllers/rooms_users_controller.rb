class RoomsUsersController < ApplicationController
  before_filter :find_room_and_user

  def create
    if current_user.rooms.find( @room )
      if !@joined_user.rooms_users.create( room_id: @room.id).new_record?
        Pusher["private-#{params[:room_id]}"].trigger_async( 'add_user_to_room', { user_id: @joined_user.id,
                                                                                   user_login: @joined_user.login,
                                                                                   rooms_name: @room.name,
                                                                                   room_id: @room.id,
                                                                                   user_status: @joined_user.user_status,
                                                                                   user_sign_out_time: @joined_user.updated_at,
                                                                                   rooms_owner_id: @room.creator_id,
                                                                                   room_members_count: @room.users.count } )
        Pusher["private-#{params[:user_id]}"].trigger_async( 'user_add_to_room', { rooms_id: @room.id,
                                                                                   rooms_name: @room.name,
                                                                                   room_owner_id: @room.creator_id,
                                                                                   user_login: @joined_user.login,
                                                                                   user_id: @joined_user.id,
                                                                                   rooms_owner_login: @room.creator.login,
                                                                                   room_members_count: @room.users.count } )
      end
      render json: { joined_user: @joined_user, room_id: @room.id, room_name: @room.name }
    end
  end

  def destroy
    room_user = @joined_user.rooms_users.where( room_id: @room ).first
    room_user.destroy
    Pusher["private-#{params[:room_id]}"].trigger_async( 'del_user_from_room', { user_login: @joined_user.login,
                                                                                 drop_user_id: params[:user_id],
                                                                                 room_name: @room.name,
                                                                                 user_status: @joined_user.user_status,
                                                                                 room_id: params[:room_id] } )

    Pusher["private-#{params[:user_id]}"].trigger_async( 'private_del_user_from_room', { room_id: params[:room_id],
                                                                                         rooms_name: @room.name } )
    render json: @joined_user, root: 'users'
  end

  def find_room_and_user
    @room = Room.find( params[:room_id] )
    @joined_user = User.find( params[:user_id] )
  end
end
