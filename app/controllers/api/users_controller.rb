module Api
  class UsersController < ApplicationController
    respond_to :json

    def search
      respond_with users = User.where("login like ? AND id != ?", "%#{params[:login]}%", current_user.id)
      #TODO
    end

    def show
      respond_with @user = User.where(:login=>params[:id]).first
    end

    def index
      friend_ids = current_user.friends.map {|item| item.id}
      if friend_ids.count == 0 && params[:search].nil?
        respond_with  @possible_friends = User.where('id != ? AND login IS NOT NULL', current_user.id).order(:lastname => :asc)
      elsif friend_ids.count == 0 && !params[:search].nil?
        respond_with @possible_friends = User.where('id != ? AND login IS NOT NULL AND firstname LIKE ?',
                                       current_user.id, "#{params[:search]}%").order(:lastname => :asc)
      else
        respond_with @possible_friends = User.where('id != ? AND login IS NOT NULL AND id NOT IN (?) AND firstname LIKE ?',
                                       current_user.id, friend_ids, "#{params[:search]}%").order(:lastname => :asc)
      end

    end

    def invite_user
      respond_with user = User.invite!(:email => params[:email],:login=>params[:email].match(/(^.*)@/)[1])
    end
  end
end