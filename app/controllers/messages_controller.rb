class MessagesController < ApplicationController
  before_filter :authenticate_user!
  include ApplicationHelper

  def create
    if RoomsUser.get_room_ids( current_user.id ).include?( params[:messages][:room_id].to_i )
      message = Message.create(message_params)

      message_hash = { id: message.id, room_id: message.room_id, messages: message.body,
                       attach_file_path: message.attach_path.url, create_at: message.created_at.strftime('%a %T') }

      if params[:messages][:message_type] == 'system'
        sent_pusher( 'new_message', message.room_id, { messages: message_hash.merge!( avatar: '../img/sys-notification.png' ) } )
      else
        message.update_attributes( user_id: current_user.id )

        sent_pusher( 'new_message', message.room_id, { messages: message_hash.merge!( user_id: current_user.id, login: current_user.login,
                                                                                     avatar: avatar_url( current_user, 50 ) ) } )

        users_in_room = RoomsUser.where( room_id: message.room_id )
        users_in_room.each { |user| sent_pusher( 'notification-room', user.user_id, { room_id: message.room_id } ) }
      end
      users = message.body.gsub( /(?<=@)(\w+)(?=\s)/ )
      emails = if users.any? && message.body.gsub(/@all/).none?
                 User.includes(:rooms_users).where( 'login = ? AND user_status = ? AND rooms_users.room_id = ?',
                                                                      users, 'Offline', params[:messages][:room_id] ).pluck(:email)
               elsif !message.body.match(/@all/).nil?
                 User.includes(:rooms_users).where( 'user_status = ? AND rooms_users.room_id = ?',
                                                                      'Offline', params[:messages][:room_id] ).pluck(:email)
               end

      sent_emails(emails, message) unless emails.blank?
      render :text => 'Success'
    end

  end

  def search
    messages = if params[:query].blank?
                 Message.where( 'room_id = ?', params[:room_id]).preload(:user).last(10)
               else
                 Message.where( 'body like ? ', "%#{params[:query]}%").where( 'room_id = ? ', params[:room_id]).preload(:user)
               end
    render :json => messages
  end

  private

  def message_params
    params.require(:messages).permit(:body, :attach_path, :room_id)
  end

  def sent_pusher(obj, id, hash)
    Pusher["private-#{id}"].trigger_async( obj, hash )
  end

  def sent_emails(emails, message)
    emails.each do |email|
      UserMailer.offline_message( email, message.body ).deliver
    end
  end

end