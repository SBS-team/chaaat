class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

   helper_method :background_image

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname,:lastname,:avatar, :email, :password, :password_confirmation,:login) }
  end

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      new_room_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def background_image()
    Dir.chdir(Rails.root+"public/background")
    target = Dir.new("#{Dir.pwd}")
    target.entries.sort![rand(2..target.entries.size-1)]
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
