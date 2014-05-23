class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :rooms_user, except: [ :new,:create,:facebook, :github ]
  before_filter :background_image, if: :devise_controller?
  #rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  #rescue_from NoMethodError, :with => :record_not_found
  before_filter :current_user_for_model

  def current_user_for_model
    Thread.current['current_user']=current_user
  end

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      gon.user_login = current_user.login
      gon.user_id = current_user.id
        rooms_path
    else
      super
    end
  end



  def after_sign_out_path_for(resource)
    Thread.current['current_user']=nil
    if current_admin_user.is_a? AdminUser
      super
    elsif resource.is_a? User
        User.update( current_user, sign_out_at: Time.now )
        root_path
      else
        super
      end
    end

  def background_image
    @background_image = Background.all.sample
  end

  private
  #def record_not_found
  #  render :file => 'public/404.html', :status => :not_found, :layout => false
  #end
  def rooms_user
    @room_list = current_user.rooms.order(id: :asc) if current_user.is_a? User
  end

  def init_gon
    gon.pusher_app=ENV['PUSHER_KEY']
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit( :email, :password, :remember_me ) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( { roles: [] }, :firstname, :lastname, :avatar, :email, :password, :password_confirmation, :login ) }
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit( :login, :firstname, :lastname, :email, :password, :password_confirmation, :current_password )
    }
    devise_parameter_sanitizer.for(:accept_invitation) { |u|
      u.permit( :firstname, :lastname, :password, :password_confirmation, :invitation_token )
    }
  end

end
