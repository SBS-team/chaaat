class RoomsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @new_room = Room.new
  end

  def index
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
  end

  def create
    @room = Room.create(room_params)
    RoomsUser.create(:user_id => current_user.id, :room_id => @room.id)
    redirect_to room_path(@room)
  end

  def show
    @message=Message.new
    @room_id=params[:id]
    gon.user_login=current_user.login
    gon.user_id=current_user.id
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:id].to_i)
      gon.room_id=params[:id]
    else
      gon.room_id=0
    end
    if RoomsUser.where(:user_id => current_user.id,:room_id => params[:id]).first
      @messages = Message.where(:room_id=>params[:id]).preload(:user).order(created_at: :desc).limit(10).reverse()
    end
    @room = Room.find(params[:id])
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
    @user_friends = current_user.friends
    room_user_ids = RoomsUser.where(:room_id => @room.id).map{|item| item.user_id}
    @room_users = User.where("id IN (?)", room_user_ids)
    gon.rooms_users=@room_users.pluck(:login)
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
