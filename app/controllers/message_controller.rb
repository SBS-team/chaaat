class MessageController < ApplicationController
  before_filter :authenticate_user!
  include MessageHelper
  include ApplicationHelper

  def new
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:message][:room_id].to_i)
      message=Message.create(message_params.merge(:user_id=>current_user.id,:body=>params[:message][:body].gsub(/[\n]/,"\r")))
      Pusher["private-#{message.room_id}"].trigger('new_message', {:room_id=>message.room_id,:user_id=>current_user.id,:login=>current_user.login,:avatar=>avatar_url(current_user,50),:message=>message.body,:create_at=>message.created_at.strftime("%a %T")})
    end
  end

  def search
    messages=Message.where("body like ? ", "%#{params[:query]}%").where("room_id = ? ",params[:room_id]).preload(:user)
    result = Array.new()
    messages.each do |res|
      message={:user_id=>res.user_id, :avatar=>avatar_url(res.user,50), :login=>res.user.login, :body=>res.body,:room_id=>res.room_id, :created_at=>res.created_at.strftime("%a %T")}
      result.push(message)
    end
    render :json=>result, :root=>false
  end

private
def message_params
  params.require(:message).permit(:body, :attach_path, :room_id)
end

end
