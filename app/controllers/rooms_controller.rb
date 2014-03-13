class RoomsController < ApplicationController
  before_filter :authenticate_user!
 def new
   @room = Room.new
 end
  def create
   @room = Room.create(room_params)
    RoomsUser.create(:user_id => current_user.id, :room_id => @room.id)
   redirect_to room_path(@room)
  end
  def show
    @room = Room.find(params[:id])
    @user_friends = current_user.friends
  end
  def update

  end
  private
  def room_params
    params.require(:room).permit( :name, :topic, :user)
  end
end
