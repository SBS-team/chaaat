class UsersController < ApplicationController
  before_filter :authenticate_user!

  def search
    users = if params[:room_id].to_i > 0
              user_id = RoomsUser.where( room_id: params[:room_id] ).pluck(:user_id)
              User.where( 'login like ? AND id != ? AND id NOT IN (?)', "%#{params[:login]}%", current_user.id, user_id )
            else
              User.where( 'login like ? AND id != ?', "%#{params[:login]}%", current_user.id )
            end
    render json: users, root: 'users'
  end

  def index
    @user = current_user
    friend_ids = current_user.friends.pluck(:id)
    @possible_friends = if friend_ids.count == 0 && params[:search].nil?
                          User.where( 'id != ? AND login IS NOT NULL', current_user.id ).order( lastname: :asc )
                        elsif friend_ids.count == 0 && !params[:search].nil?
                          User.where( 'id != ? AND login IS NOT NULL AND firstname LIKE ?',
                                      current_user.id, "#{params[:search]}%" ).order( lastname: :asc )
                        else
                          User.where( 'id != ? AND login IS NOT NULL AND id NOT IN (?) AND firstname LIKE ?',
                                      current_user.id, friend_ids, "#{params[:search]}%" ).order( lastname: :asc )
                        end
  end

  def show
    @user = User.where( login: request.path.split('/')[2] ).first
  end

  def invite_user
    user = User.invite!( email: params[:email], login: params[:email].match( /(^.*)@/ )[1] )
    render text: user.email
  end

  def change_status
    User.update( current_user.id, user_status: params[:status].gsub( /[\n]/, '' ) )
    user = User.find(current_user)
    User.update( user.id, sign_out_at: Time.now) if params[:status] == 'Offline'
    Pusher['presence-status'].trigger( 'change_status', status: user.user_status, user_id: user.id,
                                       user_sign_out_time: user.sign_out_at )
    render text: user.user_status
  end

end
