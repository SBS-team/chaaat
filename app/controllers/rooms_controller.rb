class RoomsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @new_room = Room.new
  end

  def create
   @room = Room.create(room_params)
   RoomsUser.create(:user_id => current_user.id, :room_id => @room.id)
   redirect_to room_path(@room)
  end

  def show
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
