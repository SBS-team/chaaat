class RoomsController < ApplicationController
  before_filter :authenticate_user!
 def new
   @room = Room.new
 end
  def create
   @room = Room.create(room_params)

    redirect_to room_path(@room)
  end
  def show
    @room = Room.find(params[:id])
  end
  private
  def room_params
    params.require(:room).permit( :name, :topic, :user)
  end
end
