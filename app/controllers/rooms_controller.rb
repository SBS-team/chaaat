class RoomsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @new_room = Room.new
  end

  def index
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc).preload(:user)
    @rooms_preload=RoomsUser.preload(:user)
  end

  def create
    @room = Room.create(room_params.merge(:user_id=>current_user.id))
    RoomsUser.create(:user_id => current_user.id, :room_id => @room.id)
    if params[:express]
      Pusher["private-#{params[:user_id]}"].trigger('user_add_to_room', {:rooms_id=>@room.id,:rooms_name=>@room.name})
      RoomsUser.create(:user_id => params[:user_id], :room_id => @room.id)
      render :json=>@room.id,:root=>false
    else
      @rooms_preload=RoomsUser.preload(:user)
      @room_list = Room.where("id in (?)",RoomsUser.where("user_id in (?)",current_user.id).pluck(:room_id))
      respond_to do |format|
        format.html { redirect_to rooms_path}
        format.js {}
        format.json { render json: @room_list, status: :created}
      end
    end
  end

  def show
    @message = Message.new
    @room_id = params[:id]
    gon.user_login = current_user.login
    gon.user_id = current_user.id
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:id].to_i)
      gon.room_id = params[:id]
    else
      gon.room_id = 0
    end
    if RoomsUser.where(:user_id => current_user.id,:room_id => params[:id]).first
      @messages = Message.where(:room_id=>params[:id]).preload(:user).order(created_at: :desc).limit(10).reverse()
    end
    @room = Room.find(params[:id])
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
    room_user_ids = RoomsUser.where(:room_id => @room.id).map{|item| item.user_id}
    @room_users = User.where("id IN (?)", room_user_ids)
    gon.rooms_users = @room_users.pluck(:login)
  end

  def load_previous_10_msg
    previous_messages = Message.limit(10).offset(params[:offset_records].to_i).where("room_id = ?", params[:room_id]).order(created_at: :desc).preload(:user);
    render :json => previous_messages
  end

  private
  def room_params
    params.require(:room).permit( :name, :topic)
  end

end
