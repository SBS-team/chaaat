class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :rooms_user,:except=>[:new,:create,:facebook, :github]
  before_filter :background_image, if: :devise_controller?



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

  private
  def rooms_user
    if current_user.is_a? User
      @room_list=Room.where("id in (?)",RoomsUser.where(:user_id=>current_user.id).pluck(:room_id)).order(id: :asc)
    end
  end

  def init_gon
    gon.pusher_app=ENV['PUSHER_APP']
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles: [] },:firstname,:lastname,:avatar, :email, :password, :password_confirmation, :login) }
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:login, :firstname, :lastname, :email, :password, :password_confirmation, :current_password)
    }
  end
end