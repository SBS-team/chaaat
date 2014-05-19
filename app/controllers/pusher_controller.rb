class PusherController < ApplicationController
  protect_from_forgery except: :auth # stop rails CSRF protection for this action

  def auth
    authentication_query =
        if current_user && params[:room_id].present? && current_user.rooms.present?
          current_user.rooms.find(params[:room_id]).present? &&
          ( params[:channel_name] == "private-#{params[:room_id]}" || authentication_status )
        end || authentication_status
    if authentication_query
      render json: Pusher[params[:channel_name]].authenticate( params[:socket_id], user_id: current_user.id )
    else
      render text: 'Not authorized', status: '403'
    end
  end

  def stat
    user = User.find(params[:user_id])
    if user.present?
      user_status = if params[:client_status] == 'Available' && user.user_status != 'Offline'
                      user.user_status
                    elsif params[:client_status] == 'Available'
                      'Available'
                    end || 'Offline'
      if user.update( user_status: user_status )
        Pusher['presence-status'].trigger_async( 'change_status', status: user_status, user_id: params[:user_id] )
        render text: 'Success'
      end || ( render text: 'Error' )
    end
  end

  private

  def authentication_status
    params[:channel_name] == 'presence-status' || params[:channel_name] == "private-#{current_user.id}"
  end

end