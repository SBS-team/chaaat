class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      flash[:notice] ="Could not authenticate you from Facebook. Invalid email or login."
      redirect_to new_user_registration_url
    end
  end

  def github
    user = User.create_with_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
      sign_in_and_redirect user, :event => :authentication
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      flash[:notice] ="Could not authenticate you from Github. Invalid email or login."
      redirect_to new_user_registration_url
    end
  end

  def twitter
    data = session["devise.omniauth_data"] = User.build_twitter_auth_cookie_hash(request.env["omniauth.auth"])
    user = User.find_for_twitter_oauth(data)
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect user, :event => :authentication
    elsif !user.email?
      flash[:error] = "You must add an email to complete your registration."
      @user = user
      render :add_email
    else
      flash[:notice] = "Please confirm your email first to continue."
      redirect_to new_user_confirmation_path
    end
  end


  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      flash[:notice] ="Could not authenticate you from Google. Invalid email or login."
      redirect_to new_user_registration_url
    end
  end

end