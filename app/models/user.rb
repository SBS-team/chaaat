class User < ActiveRecord::Base
  has_many :message
  has_many :room
  has_many :rooms_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:github,:facebook]

  def self.create_with_omniauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.email).first
      if registered_user
        return registered_user
      else
        user = User.create(login:auth.info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           avatar:auth.info.image,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(firstname:auth.extra.raw_info.first_name,
                           lastname:auth.extra.raw_info.last_name,
                           provider:auth.provider,
                           uid:auth.uid,
                           avatar:auth.info.image+"?width=50&height=50",
                           email:auth.info.email,
                           login:auth.extra.raw_info.username,
                           password:Devise.friendly_token[0,20],
        )
      end
    end
  end

end
