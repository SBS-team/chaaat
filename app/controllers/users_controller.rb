class UsersController < ApplicationController
  before_filter :authenticate_user!

	def search
		users=User.where("login like ?", "#{params[:login]}%")
		render :json=>users,:root=>false
	end

  def index

    @statuses = UserStat.all

    friend_ids = current_user.friends.map {|item| item.id}
    if friend_ids.count == 0 && params[:search].nil?
      @possible_friends = User.where('id != ?', current_user.id).order(:lastname => :asc)
    elsif friend_ids.count == 0 && !params[:search].nil?
      @possible_friends = User.where('id != ? AND firstname LIKE ?', current_user.id, "#{params[:search]}%").order(:lastname => :asc)
    else
      @possible_friends = User.where('id != ? AND id NOT IN (?) AND firstname LIKE ?', current_user.id, friend_ids, "#{params[:search]}%").order(:lastname => :asc)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def invite_user
    @user = User.invite!(:email => params[:email])
  end

  def change_status
    if(params[:status].to_i>0 && params[:status].to_i<=4)
      User.update(current_user.id,:user_stat_id=>params[:status].to_i)
      user=User.find(current_user)
     render text: "#{user.user_stat.status_name}"
    end
  end

end
