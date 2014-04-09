class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

def auth
    if current_user && Room.includes(:rooms_users).where('rooms_users.user_id'=>current_user.id,'rooms.id'=>params[:room_id].to_i).exists? && (params[:channel_name] == "private-#{params[:room_id]}" || params[:channel_name] == "private-#{current_user.id}")
      auth = Pusher[params[:channel_name]].authenticate(params[:socket_id],:user_id => current_user.id)
      render :json => auth
    else
      render :text => "Not authorized", :status => '403'
    end
  end

end