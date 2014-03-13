class UsersController < ApplicationController

  before_filter :authenticate_user!

  def index
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

end