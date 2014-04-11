class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    if current_user && params[:room_id]
      authentication_query=Room.includes(:rooms_users).where('rooms_users.user_id'=>current_user.id,'rooms.id'=>params[:room_id].to_i).exists? && (params[:channel_name] == "private-#{params[:room_id]}" || params[:channel_name] == "private-#{current_user.id}"|| params[:channel_name] == "presence-status")
    else
      authentication_query=params[:channel_name] == "presence-status"
    end
      if authentication_query
        auth = Pusher[params[:channel_name]].authenticate(params[:socket_id],:user_id => current_user.id)
        render :json => auth
      else
        render :text => "Not authorized", :status => '403'
      end
  end

  def stat
    previous_status=User.find(params[:user_id]).user_status
    if params[:client_status]=='Available' && previous_status!='Offline'
      user_status=previous_status
    elsif params[:client_status]=='Available'
      user_status='Available'
    else
      user_status='Offline'
    end
    Pusher['presence-status'].trigger_async('change_status', :status=>user_status,:user_id=>params[:user_id])
    User.update(params[:user_id], :user_status =>user_status)
    render :text=>"Success"
  end

end