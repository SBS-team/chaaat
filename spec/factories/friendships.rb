# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#


require 'factory_girl'
FactoryGirl.define do
  factory :friendship do
    friend_id 2
    user_id 1
  end
end
