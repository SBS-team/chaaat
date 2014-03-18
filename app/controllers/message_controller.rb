class MessageController < ApplicationController
	before_filter :authenticate_user!
  include MessageHelper

	def index
		@messages=Message.all.preload(:user)
    #@messages.each do |message|
    #  message.body.sub!(/[\n]/,raw('<br>'))
    #end
	end

  def new
    message=Message.create(:user_id=>current_user.id,:body=>params[:message])
    Pusher['private'].trigger('new_message', {:user_id=>current_user.id,:login=>current_user.login,:message=>message.body ,:create_at=>message.created_at.strftime("%T")})
  end

	def show
		@messages=Message.all.preload(:user)
	end

  def search
    messages=Message.where("body like ?", "%#{params[:query]}%").preload(:user)
    result = Array.new()
    messages.each do |res|
      message={:user_id=>res.user_id, :login=>res.user.login, :body=>res.body, :created_at=>res.created_at.strftime("%a %T")}
      result.push(message)
    end
    render :json=>result
  end

end
