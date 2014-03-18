class MessageController < ApplicationController
	before_filter :authenticate_user!
  include MessageHelper

  def new
    message=Message.create(:user_id=>current_user.id,:body=>params[:message])
    Pusher['private'].trigger('new_message', {:user_id=>current_user.id,:login=>current_user.login,:message=>message.body ,:create_at=>message.created_at.strftime("at %T")})
  end

	def show
    gon.user_id=current_user.id
    @messages=Message.all.preload(:user)
	end

  def search
    messages=Message.where("body like ?", "%#{params[:query]}%").preload(:user)
    render json: messages, :root=>false
  end

end
