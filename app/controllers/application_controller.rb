class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :rooms_user,:except=>[:new,:create,:facebook]
  before_filter :init_gon

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      gon.user_login = current_user.login
      gon.user_id = current_user.id
        Pusher['status'].trigger_async('change_status', :status=>"Available",:user_id=>current_user.id) #FIXME remove
        User.update(current_user.id, :user_status =>"Available") #FIXME use pusher hooks
        rooms_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource)
    Pusher['status'].trigger_async('change_status', :status=>"Offline",:user_id=>current_user.id) #FIXME remove
    User.update(current_user.id, :user_status =>"Offline") #FIXME use pusher hooks
    User.update(current_user.id, :sign_out_at => Time.now)
    if resource.is_a? User
      root_path
    else
      super
    end
  end

  private
  def rooms_user
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc) #FIXME
  end
    
  def init_gon
      gon.pusher_app=ENV['PUSHER_APP']
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles: [] },:firstname,:lastname,:avatar, :email, :password, :password_confirmation, :login) }
  end


  # Prevent CSRF attacks by raising an exception. #FIXME cleanup commented code
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
end
