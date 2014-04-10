class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :rooms_user,:except=>[:new,:create,:facebook]
  helper_method :background_image


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
    User.update(current_user.id, :sign_out_at => Time.now)
    if resource.is_a? User
      root_path
    else
      super
    end
  end

  def background_image()
    Dir.chdir(Rails.root+"public/background")
    target = Dir.new("#{Dir.pwd}")
    target.entries.sort![rand(2..target.entries.size-1)] #FIXME carrierwave?
  end

  private
  def rooms_user
    @room_list=Room.includes(:rooms_users).where('rooms_users.user_id'=>current_user.id).preload(:user).order(id: :asc)
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles: [] },:firstname,:lastname,:avatar, :email, :password, :password_confirmation, :login) }
  end

end
