class MessageController < ApplicationController
	before_filter :authenticate_user!
  include MessageHelper

	def index
    gon.user_id = current_user.id
		@messages=Message.all.preload(:user)
	end


  def new
    message=Message.create(:user_id=>current_user.id,:body=>params[:message].gsub(/[\n]/,"\r"))
    Pusher['private'].trigger('new_message', {:user_id=>current_user.id,:login=>current_user.login,:message=>message.body ,:create_at=>message.created_at.strftime("%a %T")})
  end

	def show
    gon.user_id=current_user.id
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
    render json: messages, :root=>false
  end

end
