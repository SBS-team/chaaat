class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    if current_user && params[:channel_name] == "private-#{params[:room_id]}"
        #params[:channel_name] == "private-#{current_user.id}"#change this after correct rooms
      auth = Pusher[params[:channel_name]].authenticate(params[:socket_id],
                                                        :user_id => current_user.id # => required
      )
      render :json => auth
    else
      render :text => "Not authorized", :status => '403'
    end
    end
end