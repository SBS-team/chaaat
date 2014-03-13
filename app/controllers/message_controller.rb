class MessageController < ApplicationController
	before_filter :authenticate_user!

	def index
		@messages=Message.all.preload(:user)
	end

	def show
		@messages=Message.all.preload(:user)
	end

	def new
		message=Message.create(:user_id=>current_user.id,:body=>params[:message])
		Pusher['chaaat'].trigger('my_event', {:firstname=>current_user.firstname,:message=>message.body ,:create_at=>message.created_at.strftime("%T")})
	end

	def search
		search=Message.where("body like ?", "%#{params[:query]}%")
		render :json=>search.to_json 
	end

end
