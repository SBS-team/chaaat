class UserMailer < ActionMailer::Base
  default :from => "chaaat.chaaat@gmail.com"

  def welcome_email(user)
    @user = user
    @url = ENV["HOSTNAME_SITE"]
    mail(to: @user.email, subject: 'Welcome to '+ENV["TITLE_SITE"])
  end

	def offline_message(user,message)
		@user = user
		@message = message
    mail(to: @user, subject: 'Someone write you!')
  end

end
