class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :rooms_user,:except=>[:new,:create,:facebook]
  before_filter :background_image, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      gon.room_id = 0
      gon.user_id = current_user.id
      @room_list = Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
        Pusher['status'].trigger_async('change_status', :status=>"Available",:user_id=>current_user.id)
        User.update(current_user.id, :user_status =>"Available")
        rooms_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource)
  if current_admin_user.is_a? AdminUser
    super
    else
      Pusher['status'].trigger_async('change_status', :status=>"Offline",:user_id=>current_user.id)
      User.update(current_user.id, :user_status =>"Offline")
      User.update(current_user.id, :sign_out_at => Time.now)
      if resource.is_a? User
        root_path
      else
        super
      end
    end
  end


  def background_image
    backgrounds = Background.all.shuffle
    @background_image = backgrounds.first
  end
  #unless
  #  rescue_from Exception, with: lambda { |exception| render_error 500, exception }
  #  rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  #end

  #private
  #def render_error(status, exception)
  #  respond_to do |format|
  #    format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
  #    format.all { render root_path, status: status }
  #  end
  #end

  def rooms_user
    if current_user.is_a? User
    @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
    end
    #@room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles: [] },:firstname,:lastname,:avatar, :email, :password, :password_confirmation, :login) }
  end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
end
