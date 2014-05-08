class UserMailer < ActionMailer::Base
  default :from => "chaaat.chaaat@gmail.com"


  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Chaaat!')
  end
	def offline_message(user,message,room)
		@user = user
		@message = message
    @room = room
    mail(to: @user, subject: 'Someone write you!')
	end
end
