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


require 'factory_girl'
FactoryGirl.define do
  factory :rooms_user do
    user nil
    room nil
  end
end
