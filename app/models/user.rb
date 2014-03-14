class User < ActiveRecord::Base
  has_many :message
  has_many :room
  has_many :rooms_users
  devise :omniauthable, :omniauth_providers => [:github,:facebook]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #def self.create_with_omniauth(auth)
  #  create! do |user|
  #    user.provider = auth[provider]
  #    user.uid = auth[uid]
  #    user.firstname = auth[info][name]
  #  end
  #end

  def self.create_with_omniauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.email).first
      if registered_user
        return registered_user
      else
        user = User.create(firstname:auth.info.name,
                           provider:auth.provider,
                           uid:auth.uid,
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
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
        )
      end
    end
  end

end
