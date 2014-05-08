class UsersController < ApplicationController
  before_filter :authenticate_user!

  def search
    users = User.where("login like ? AND id != ?", "%#{params[:login]}%", current_user.id)
    render :json => users, :root => "users"
  end


  def index
    friend_ids = current_user.friends.map {|item| item.id}
    if friend_ids.count == 0 && params[:search].nil?
      @possible_friends = User.where('id != ? AND login IS NOT NULL', current_user.id).order(:lastname => :asc)
    elsif friend_ids.count == 0 && !params[:search].nil?
      @possible_friends = User.where('id != ? AND login IS NOT NULL AND firstname LIKE ?',
                                     current_user.id, "#{params[:search]}%").order(:lastname => :asc)
    else
      @possible_friends = User.where('id != ? AND login IS NOT NULL AND id NOT IN (?) AND firstname LIKE ?',
                                     current_user.id, friend_ids, "#{params[:search]}%").order(:lastname => :asc)
    end
  end

  def show
    @user = User.where(:login=>request.path.split('/')[2].gsub('.json', '')).first
  end

  def invite_user
    user = User.invite!(:email => params[:email],:login=>params[:email].match(/(^.*)@/)[1])
    render :text=>user.email
  end

  def change_status
    User.update(current_user.id,:user_status=>params[:status].gsub(/[\n]/,""))
    user = User.find(current_user)

    if(params[:status] == "Offline")
      User.update(user.id, :sign_out_at => Time.now)
    end
    Pusher['presence-status'].trigger('change_status', :status=>user.user_status,:user_id=>user.id,:user_sign_out_time=>user.sign_out_at)

    render text: "#{user.user_status}"
  end

end
