class RoomsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_gon

  def new
    @new_room = Room.new
  end

  def index
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc).preload(:user) #FIXME refactoring
    @rooms_preload=RoomsUser.preload(:user)
  end

  def create
    @room = Room.create(room_params.merge(:user_id=>current_user.id)) #FIXME refactoring (create)
    RoomsUser.create(:user_id => current_user.id, :room_id => @room.id) #FIXME refactoring (create)
    if params[:express]
      Pusher["private-#{params[:user_id]}"].trigger_async('user_add_to_room', {:rooms_id=>@room.id,:rooms_name=>@room.name})
      RoomsUser.create(:user_id => params[:user_id], :room_id => @room.id)
      render :json=>@room.id,:root=>false
    else
      @rooms_preload=RoomsUser.preload(:user)#FIXME refactoring
      @room_list = Room.where("id in (?)",RoomsUser.where("user_id in (?)",current_user.id).pluck(:room_id)) #FIXME refactoring
      respond_to do |format|
        format.html { redirect_to rooms_path}
        format.js {} #FIXME remove
        format.json { render json: @room_list, status: :created}
      end
    end
  end

  def show #FIXME refactoring (tut vse ploho)
    @message = Message.new
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:id].to_i) #FIXME refactoring
      gon.room_id = params[:id]
    else
      gon.room_id = 0
    end
    if RoomsUser.where(:user_id => current_user.id,:room_id => params[:id]).first
      @messages = Message.where(:room_id=>params[:id]).preload(:user).order(created_at: :desc).limit(10).reverse() #FIXME wat?
    end
    @room = Room.find(params[:id])
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc) #FIXME refactoring
    room_user_ids = RoomsUser.where(:room_id => @room.id).map{|item| item.user_id}
    @room_users = User.where("id IN (?)", room_user_ids)
    gon.rooms_users = @room_users.pluck(:login)
  end

  def delete_room
    room=Room.where("user_id = ? AND id = ?",current_user.id,params[:id]).first
    room.destroy
    Pusher['status'].trigger('delete_room', :room_id=>params[:id])
  end

  def load_previous_10_msg
    previous_messages = Message.limit(10).offset(params[:offset_records].to_i).where("room_id = ?", params[:room_id]).order(created_at: :desc).preload(:user); #FIXME wat?
    previous_messages.sort!
    render :json => previous_messages, :root=>"message"
  end

  private

  def init_gon
    gon.pusher_app=ENV['PUSHER_APP']
    gon.user_login = current_user.login
    gon.user_id = current_user.id
  end

  def room_params
    params.require(:room).permit( :name, :topic)
  end

end
