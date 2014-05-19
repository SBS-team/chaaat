# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  firstname              :string(255)
#  lastname               :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  sign_out_at            :datetime
#  login                  :string(255)
#  avatar                 :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  profile_avatar         :string(255)
#  user_status            :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  has_many :message, dependent: :destroy
  has_many :room, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :rooms_users, dependent: :destroy
  has_many :friends, :through => :friendships
  validates :email, :encrypted_password, :presence => true
  validates_uniqueness_of :login, :message => "has already been taken"
  validates :login, format: { with: /\A[a-zA-Z0-9._-]+\Z/ }
  validates :login, length: 1..12, :presence => true
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:github, :facebook, :twitter, :google_oauth2]
  before_save :default_stat

  def self.create_with_omniauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid.to_s).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.email).first
      if registered_user
        return registered_user
      else
        User.create(
            firstname:auth.info.name,
            login:auth.extra.raw_info.login,
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password:Devise.friendly_token[0,20]
        )

      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info.tap {|u|
      logger.info "*" * 25 + "USER INFO " + "*" * 25

      logger.info data

      logger.info "*" * 50
    }
    user = User.where(:email => data["email"]).first

    unless user
         user = User.create(name: data["name"],
            email: data["email"],
            password: Devise.friendly_token[0,20]
         )
    end
    user
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)  #FIXME refactoring
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        User.create(firstname:auth.extra.raw_info.first_name,
                    lastname:auth.extra.raw_info.last_name,
                    provider:auth.provider,
                    uid:auth.uid,
                    avatar:auth.info.image+"?width=50&height=50",
                    profile_avatar:auth.info.image+"?width=125&height=125",
                    email:auth.info.email,
                    login:auth.extra.raw_info.username,
                    password:Devise.friendly_token[0,20]
        )
      end
    end
  end

  private
  def default_stat
     if self.user_status==nil
     self.user_status="Offline"
    end
  end
end
