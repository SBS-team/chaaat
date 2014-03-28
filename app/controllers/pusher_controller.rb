class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action
  include ApplicationHelper

  def auth
     if current_user && (params[:channel_name] == "private-#{params[:room_id]}" || params[:channel_name] == "private-#{current_user.id}")
      auth = Pusher[params[:channel_name]].authenticate(params[:socket_id],:user_id => current_user.id)
      render :json => auth
    else
      render :text => "Not authorized", :status => '403'
    end
  end

  def typing_status
    Pusher['private-'+"#{params[:room_id]}"].trigger('typing_status', :login=>params[:login])
    render :text => ""
  end

  def change_status
    if(params[:status].to_i>0 && params[:status].to_i<=4)
      User.update(current_user.id,:user_stat_id=>params[:status].to_i)
      Pusher['status'].trigger('change_status', :status=>current_user.user_stat.status_name,:user_id=>current_user.id,:user_sign_out_time=>current_user.sign_out_at)
      render text: "#{current_user.user_stat.status_name}"
    end
  end

end