class Room < ActiveRecord::Base
  has_many :message
  has_many :rooms_users
end
