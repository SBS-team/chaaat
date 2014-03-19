class RoomsUser < ActiveRecord::Base

# == Schema Information
#
# Table name: rooms_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  room_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
  belongs_to :user
  belongs_to :room

  validates :user_id, uniqueness: true
end
