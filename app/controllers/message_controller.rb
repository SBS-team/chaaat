class MessageController < ApplicationController

	def index
		@messages=Message.all.preload(:user)
	end

	def new
		Pusher['chaaat'].trigger('my_event', {:firstname=>current_user.firstname,:lastname=>current_user.lastname,message: params[:message]})
		message=Message.create(:user_id=>current_user.id,:body=>params[:message])
	end
end
