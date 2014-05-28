class MessagesController < ApplicationController
  before_filter :authenticate_user!
  include ApplicationHelper

  def create
    message = Message.new( message_params )
    if message.save
      standard_hash = { id: message.id, room_id: message.room_id, messages: message.body,
                        attach_file_path: message.attach_path.url, create_at: message.created_at.strftime('%a %T') }
      if params[:messages][:message_type] == 'system'
        prepare_pusher_data( message, standard_hash, avatar: '../img/sys-notification.png' )
      else
        if message.update( user_id: current_user.id )
          prepare_pusher_data( message, standard_hash, user_id: current_user.id, login: current_user.login, lastname: current_user.lastname, firstname: current_user.firstname, avatar: avatar_url( current_user, 50 ) )
          message.room.users.each { |user| sent_pusher( 'notification-room', user.id, { room_id: message.room_id } ) }
        end
      end
      message.send_emails
      render text: 'Success'
    else

      render template: 'layouts/limit_message'
    end
  end

  def search
    messages = if params[:query].blank?
                 Message.where( room_id: params[:room_id]).preload(:user).last(10)
               else
                 Message.where( 'body like ? AND room_id = ?', "%#{params[:query]}%", params[:room_id] ).preload( :user )
               end
    render json: messages
  end

  private

  def message_params
    params.require(:messages).permit(:body, :attach_path, :room_id)
  end

  def sent_pusher( obj, id, hash )
    Pusher["private-#{id}"].trigger_async( obj, hash )
  end

  def prepare_pusher_data( message, standard_hash, hash )
    sent_pusher( 'new_message', message.room_id, { messages: standard_hash.merge!( hash ) } )
  end

end
