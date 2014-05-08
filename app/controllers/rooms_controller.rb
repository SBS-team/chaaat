class RoomsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_gon

  def new
    @new_room = Room.new
  end

  def index
    @rooms_preload=RoomsUser.all
  end

  def create
    @room = Room.create(room_params.merge(:user_id=>current_user.id))
    RoomsUser.create(:user_id => current_user.id, :room_id => @room.id)
    if params[:express]
      Pusher["private-#{params[:user_id]}"].trigger_async('user_add_to_room',{:rooms_id=>@room.id,:rooms_name=>@room.name,
                                                                              :room_owner_id => @room.user_id,
                                                                              :user_login => current_user.login,
                                                                              :user_id => current_user.id,
                                                                              :rooms_owner_login => current_user.login,
                                                                              :room_members_count => "2"})
      RoomsUser.create(:user_id => params[:user_id], :room_id => @room.id)
      render :json=>@room.id,:root=>false
    else
      @rooms_preload = RoomsUser.preload(:user)
      @room_list = Room.includes(:rooms_users).where('rooms_users.user_id' => current_user.id).preload(:user).order(id: :asc)
      respond_to do |format|
        format.html { redirect_to rooms_path}
        format.js {}
        format.json { render json: @room_list, status: :created}
      end
    end
  end

  def show
    if Room.includes(:rooms_users).where('rooms_users.user_id'=>current_user.id,'rooms.id'=>params[:id].to_i).exists?
      @room=Room.find(params[:id])
      @message = Message.new
      gon.room_id = params[:id]
      @message_count = Message.where(:room_id=>params[:id]).count
      @messages = Message.where(:room_id=>params[:id]).preload(:user).order(created_at: :asc).last(10)
      @links = Message.where("room_id = ? AND (body LIKE ? OR body LIKE ? OR body LIKE ?)",params[:id],"%http://%","%https://%","%ftp://%").preload(:user).order(created_at: :asc)
      @attah = Message.where("room_id = ? AND attach_path IS NOT NULL",params[:id]).preload(:user).order(created_at: :asc)
      @room_users = User.includes(:rooms_users).where('rooms_users.room_id'=>params[:id])
      gon.rooms_users = @room_users.pluck(:login)
    else
      gon.room_id = 0
    end
    @room_list = Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
    room_user_ids = RoomsUser.where(:room_id => @room.id).map{|item| item.user_id}
    gon.user_login = current_user.login
    gon.user_id = current_user.id
    @cur_user_present_in_room = room_user_ids.to_a.include? current_user.id
  end

  def update
    room = Room.find(params[:room_id])
    previous_topic=room.topic
    if RoomsUser.where('user_id=? AND room_id=?',current_user.id,params[:room_id]).first
      Pusher["private-#{params[:room_id]}"].trigger('change-topic',:topic=>params[:query])
      room.update(:topic=>params[:query])
    end
    render :json=>{:curr_topic=>params[:query],:prev_topic=>previous_topic}
  end

  def destroy
    room = Room.where("user_id = ? AND id = ?",current_user.id,params[:id]).first
    room.destroy
    Pusher['status'].trigger('delete_room', :room_id=>params[:id])
    render :text => "Success"
  end

  def load_previous_10_msg
    if Room.includes(:rooms_users).where('rooms_users.user_id'=>current_user.id,'rooms.id'=>params[:room_id].to_i).exists?
      previous_messages = Message.where("room_id = ? AND id < ?", params[:room_id],params[:messages]).order(created_at: :asc).last(10);
      previous_messages.sort!
      render :json =>previous_messages, :root=>"messages"
    end
  end


  private
  def init_gon
    gon.pusher_app = ENV['PUSHER_KEY']
    gon.user_login = current_user.login
    gon.user_id = current_user.id
  end

  def room_params
    params.require(:room).permit( :name, :topic)
  end

end
