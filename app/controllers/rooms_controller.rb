class RoomsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_gon
  before_filter :find_room, only: [ :show, :update ]
  before_filter :get_room_list, only: [ :show, :create ]

  def new
    @new_room = Room.new
  end

  def index
  end

  def create
    @room = current_user.build.rooms( room_params )
    RoomsUser.create( user_id: current_user.id, room_id: @room.id )
    if params[:express]
      Pusher["private-#{params[:user_id]}"].trigger_async( 'user_add_to_room', { rooms_id: @room.id,
                                                                                 rooms_name: @room.name,
                                                                                 room_owner_id: @room.creator_id,
                                                                                 user_login: current_user.login,
                                                                                 user_id: current_user.id,
                                                                                 rooms_owner_login: current_user.login,
                                                                                 room_members_count: '2' } )
      RoomsUser.create( user_id: params[:user_id], room_id: @room.id )
      render json: @room.id, root: false
    else
      respond_to do |format|
        format.html { redirect_to rooms_path}
        format.js {}
        format.json { render json: @room_list, status: :created }
      end
    end
  end

  def show
    @room_users = @room.users
    @message = Message.new
    @messages = Message.where( room_id: params[:id] ).preload( :user )
    @links = Message.get_body_links(@messages)
    @attach = Message.get_body_attach(@messages)

    gon.room_id = params[:id]
    gon.rooms_users = @room_users.pluck(:login)
    gon.user_login = current_user.login
    gon.user_id = current_user.id
  end

  def update
    previous_topic = @room.topic
      if RoomsUser.where( 'user_id=? AND room_id=?', current_user.id, params[:id] ).first
        Pusher["private-#{params[:id]}"].trigger( 'change-topic', topic: params[:query] )
        @room.update( topic: params[:query] )
        end
    render json: { curr_topic: params[:query], prev_topic: previous_topic }
  end

  def destroy
    room = Room.where( 'creator_id = ? AND id = ?', current_user.id, params[:id] ).first
    room.destroy
    Pusher['status'].trigger( 'delete_room', room_id: params[:id] )
    render text: 'Success'
  end



  def load_previous_10_msg
    if Room.includes(:rooms_users).where( 'rooms_users.user_id' => current_user.id, 'rooms.id' => params[:room_id].to_i ).exists?
      previous_messages = Message.where( 'room_id = ? AND id < ?', params[:room_id], params[:messages] ).order(created_at: :asc).last(10);
      previous_messages.sort!
      render json: previous_messages, root: 'messages'
    end
  end


  private
  def init_gon
    gon.pusher_app = ENV['PUSHER_KEY']
    gon.user_login = current_user.login
    gon.user_id = current_user.id
  end

  def room_params
    params.require(:room).permit( :name, :topic )
  end

  def find_room
    @room = Room.find(params[:id])
  end

  def get_room_list
    @room_list = current_user.rooms.order(id: :asc)
  end

end
