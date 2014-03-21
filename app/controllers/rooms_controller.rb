class RoomsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @new_room = Room.new
  end

  def index
    @room=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id))

    #@room = Room.find(params[:id])
    #@user_friends = current_user.friends
    #room_user_ids = RoomsUser.where(:room_id => @room.id).map{|item| item.user_id}
    #@room_users = User.where("id IN (?)", room_user_ids)
  end

  def create
   @room = Room.create(room_params)
   RoomsUser.create(:user_id => current_user.id, :room_id => @room.id)
   redirect_to room_path(@room)
  end

  def show
    gon.user_id=current_user.id
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:id].to_i)
   #if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).first!=params[:room_id]
      gon.room_id=params[:id]
    else
      gon.room_id=0
    end
  gon.test=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id)

    if RoomsUser.where(:user_id => current_user.id,:room_id => params[:id]).first
      @messages=Message.where(:room_id=>params[:id]).preload(:user)
    end
    @room = Room.find(params[:id])
    @user_friends = current_user.friends
    room_user_ids = RoomsUser.where(:room_id => @room.id).map{|item| item.user_id}
    @room_users = User.where("id IN (?)", room_user_ids)

  end

  private
    def room_params
      params.require(:room).permit( :name, :topic)
    end
end
