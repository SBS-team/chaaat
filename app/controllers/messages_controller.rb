class MessagesController < ApplicationController
  before_filter :authenticate_user!
  include ApplicationHelper

  def create
    if Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:messages][:room_id].to_i)
      if params[:messages][:message_type]=="system"
        message=Message.create(message_params.merge(:body=>params[:messages][:body]))
        Pusher["private-#{message.room_id}"].trigger_async('new_message', :messages=>{:id=>message.id,
                                                                                      :room_id=>message.room_id,
                                                                                      :avatar=>"../img/sys-notification.png",
                                                                                      :messages=>message.body,
                                                                                      :attach_file_path=>message.attach_path.url,
                                                                                      :create_at=>message.created_at.strftime("%a %T")})
      else
        message_sent=Message.create(message_params.merge(:user_id=>current_user.id,:body=>params[:messages][:body]))
        message=Message.find(message_sent.id)
        Pusher["private-#{message.room_id}"].trigger_async('new_message', :messages=>{:id=>message.id,
                                                                                      :room_id=>message.room_id,
                                                                                      :user_id=>current_user.id,
                                                                                      :login=>current_user.login,
                                                                                      :avatar=>avatar_url(current_user,50),
                                                                                      :messages=>message.body,
                                                                                      :attach_file_path=>message.attach_path.url,
                                                                                      :create_at=>message.created_at.strftime("%a %T")})
        users_in_room=RoomsUser.where(:room_id=>message.room_id)
        users_in_room.each {|user|    Pusher["private-#{user.user_id}"].trigger_async('notification-room',:room_id=>message.room_id)}
      end
      users=message.body.gsub(/(?<=@)(\w+)(?=\s)/)
      if users.any? && message.body.gsub(/@all/).none?
        offline_user_emails=User.includes(:rooms_users).where('login = ? AND user_status = ? AND rooms_users.room_id = ?',
                                                              users,"Offline",params[:messages][:room_id]).pluck(:email)
        offline_user_emails.each do |email|
          UserMailer.offline_message(email,message.body,params[:messages][:room_id]).deliver
        end
      elsif !message.body.match(/@all/).nil?
        offline_user_emails=User.includes(:rooms_users).where('user_status = ? AND rooms_users.room_id = ?',
                                                              "Offline",params[:messages][:room_id]).pluck(:email)
        offline_user_emails.each do |email|
          UserMailer.offline_message(email,message.body,params[:messages][:room_id].to_i).deliver
        end
      end

      render :text => 'Success'
    end
    #render :nothing => true
  end

  def search
    if params[:query].blank?
      messages = Message.where("room_id = ?", params[:room_id]).preload(:user).last(10)
    else
      messages=Message.where("body like ? ", "%#{params[:query]}%").where("room_id = ? ",params[:room_id]).preload(:user)
    end
    render :json => messages
  end

  private

  def message_params
    params.require(:messages).permit(:body, :attach_path, :room_id)
  end

end