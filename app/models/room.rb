# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  topic      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Room < ActiveRecord::Base
  has_many :message, dependent: :destroy
  has_many :rooms_users, dependent: :destroy
  belongs_to :user

  #FIXME validates?
end
