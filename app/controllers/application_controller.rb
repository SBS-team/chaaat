class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname,:lastname, :email, :password, :password_confirmation) }
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
