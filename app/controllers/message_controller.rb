class MessageController < ApplicationController
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

  def search
    messages=Message.where("body like ? ", "%#{params[:query]}%").where("room_id = ? ",params[:room_id]).preload(:user)
    result = Array.new()
    messages.each do |res|
      message={:user_id=>res.user_id, :login=>res.user.login, :body=>res.body,:room_id=>res.room_id, :created_at=>res.created_at.strftime("%a %T")}
      result.push(message)
    end
    render :json=>result, :root=>false
  end

end
