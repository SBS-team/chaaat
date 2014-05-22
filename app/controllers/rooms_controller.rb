class RoomsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_gon
  before_filter :find_room, only: [ :show, :update, :destroy, :load_previous_10_msg ]
  before_filter :get_room_list, only: [ :show, :create ]

  def new
    @new_room = Room.new
  end

  def index
    @rooms_preload = RoomsUser.all
  end

  def create
    @room = Room.new( room_params.merge!( creator_id: current_user.id.to_i ) )
    if @room.save
      @room.create_rooms_user_object( current_user.id )
      if params[:express]
        Pusher["private-#{params[:user_id]}"].trigger_async( 'user_add_to_room', { rooms_id: @room.id,
                                                                                   rooms_name: @room.name,
                                                                                   room_owner_id: @room.creator_id,
                                                                                   user_login: current_user.login,
                                                                                   user_id: current_user.id,
                                                                                   rooms_owner_login: current_user.login,
                                                                                   room_members_count: '2' } )
        @room.create_rooms_user_object( params[:user_id] )
        render json: @room.id, root: false
      else
        respond_to do |format|
          format.html { redirect_to rooms_path}
          format.js {}
          format.json { render json: @room_list, status: :created }
        end
      end
    else
      render template: 'layouts/limit_message'
    end
  end

  def show
    @room_users = @room.users
    @room_list = current_user.rooms.order(id: :asc)
    @message = Message.new
    @messages = @room.messages.preload(:user)
    @links = Message.get_body_links(@messages).order(created_at: :desc).paginate( page: params[:page], per_page: 10)
    @attach = Message.get_body_attach(@messages).order(created_at: :asc)

    gon.room_id = params[:id].to_i
    gon.rooms_users = @room_users.pluck(:login)
    gon.user_login = current_user.login
    gon.user_id = current_user.id

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @order_requests }
      format.js
    end
  end

  def update
    previous_topic = @room.topic
    if current_user.rooms.pluck(:id).include?( params[:room_id].to_i )
      Pusher["private-#{params[:id]}"].trigger( 'change-topic', topic: params[:query] )
      @room.update( topic: params[:query] )
    end
    render json: { curr_topic: params[:query], prev_topic: previous_topic }
  end

  def destroy
    if @room.destroy
      Pusher['status'].trigger( 'delete_room', room_id: params[:id] )
      render text: 'Success'
    else
      render text: 'Shit happens'
    end
  end

  def load_previous_10_msg
    if @room
      previous_messages = @room.messages.where( 'id < ?', params[:messages] ).order(created_at: :asc).last(10)
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
    @room = Room.find( params[:id] || params[:room_id] )
  end

  def get_room_list
    @room_list = current_user.rooms.order(id: :asc)
  end

end
