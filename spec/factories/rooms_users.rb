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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rooms_user do
    user_id 1
    room_id 1
  end
end
