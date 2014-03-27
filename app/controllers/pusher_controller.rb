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

  def pagination
    messages=Message.where(:room_id=>params[:room_id]).preload(:user).last(params[:pag_count].to_i)
    result = Array.new()
    messages.each do |res|
      message={:user_id=>res.user_id, :avatar=>avatar_url(res.user),:login=>res.user.login, :body=>res.body,:room_id=>res.room_id, :created_at=>res.created_at.strftime("%a %T")}
      result.push(message)
    end
    render :json=>result, :root=>false
  end

end