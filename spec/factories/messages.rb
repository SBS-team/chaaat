# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  body        :text
#  attach_path :text
#  attach_size :text
#  room_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_messages_on_room_id  (room_id)
#  index_messages_on_user_id  (user_id)
#

require 'factory_girl'
FactoryGirl.define do
  factory :message do
    user nil
    body "MyText"
    attach_path "MyText"
    attach_size "MyText"
    room nil
  end
end
