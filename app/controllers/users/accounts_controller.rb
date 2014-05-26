class Users::AccountsController < ApplicationController

  def create
    data = session["devise.omniauth_data"]
    data[:email] = params[:user][:email]
    @user = User.find_for_twitter_oauth(data)
    @user.email = data[:email]
    if @user.save
      flash[:notice] = I18n.t "devise.registrations.signed_up_but_unconfirmed"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:error] = I18n.t "devise.omniauth_callbacks.failure", :kind => data[:provider].titleize, :reason => @user.errors.full_messages.first
      render "users/omniauth_callbacks/add_email"
    end
  end

end