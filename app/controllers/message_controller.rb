class MessageController < ApplicationController
<<<<<<< HEAD

	def index
		@messages=Message.all.preload(:user)
	end

	def new
		Pusher['chaaat'].trigger('my_event', {:firstname=>current_user.firstname,:lastname=>current_user.lastname,message: params[:message]})
		message=Message.create(:user_id=>current_user.id,:body=>params[:message])
	end
=======
	before_filter :authenticate_user!

  include ApplicationHelper

	def index
    #gon.user_id = current_user.id
		#@messages=Message.all.preload(:user)
	end


  def new

    if  Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).pluck(:id).include?(params[:room_id].to_i)
      message=Message.create(:user_id=>current_user.id,:body=>params[:message].gsub(/[\n]/,"\r"),:room_id=>params[:room_id])
      Pusher['private-'+"#{params[:room_id]}"].trigger('new_message', {:room_id=>params[:room_id],:user_id=>current_user.id,:login=>current_user.login,:avatar=>avatar_url(current_user),:message=>message.body,:create_at=>message.created_at.strftime("%a %T")})
    end
  end

	def show
    gon.user_id=current_user.id
    @messages=Message.all.preload(:user).order(created_at: :asc)
	end


>>>>>>> develop
end
