class UserMailer < ActionMailer::Base
  default :from => "chaaat.chaaat@gmail.com"


  def welcome_email(user)
    @user = user
    @url = "http://localhost:3000"
    mail(to: @user.email, subject: 'Welcome to InYourShoes!')
  end
	def offline_message(user,message)
		@user = user
		@message = message
    mail(to: @user, subject: 'Someone write you!')
	end
end
