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



FactoryGirl.define do
  factory :friendship do
    user_id 1
    friend_id 1
  end
end
