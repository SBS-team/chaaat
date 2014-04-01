class MessageController < ApplicationController
  before_filter :authenticate_user!
  include ApplicationHelper

  def new
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:message][:room_id].to_i)
      message=Message.create(message_params.merge(:user_id=>current_user.id,:body=>params[:message][:body].gsub(/[\n]/,"\r")))
      Pusher["private-#{message.room_id}"].trigger('new_message', {:room_id=>message.room_id,:user_id=>current_user.id,:login=>current_user.login,:avatar=>avatar_url(current_user,50),:message=>message.body,:attach_file_path=>message.attach_path.url,:create_at=>message.created_at.strftime("%a %T")})
      users=message.body.gsub(/(?<=@)(\w+)(?=\s)/)
      if !users
      offline_user_emails=User.where("login IN (?) AND user_status='Offline' AND id IN (?)", users, RoomsUser.where("room_id IN (?)",params[:message][:room_id]).pluck(:user_id)).pluck(:email)
        offline_user_emails.each do |email|
        UserMailer.offline_message(email,message.body).deliver 
      end

    end
    end
    redirect_to room_path(params[:message][:room_id])
  end

  def search
    if params[:query].blank?
      messages = Message.where("room_id = ?", params[:room_id]).preload(:user).last(10)
    else
      messages=Message.where("body like ? ", "%#{params[:query]}%").where("room_id = ? ",params[:room_id]).preload(:user)
    end
    render :json => messages, :root => false
  end

  private

  def message_params
    params.require(:message).permit(:body, :attach_path, :room_id)
  end

end
