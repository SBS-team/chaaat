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



FactoryGirl.define do
  factory :rooms_user do
    user_id 1 #FIXME
    room_id 1 #FIXME
  end
end
