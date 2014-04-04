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



class Message < ActiveRecord::Base
  require 'carrierwave'
  belongs_to :user
  belongs_to :room
  mount_uploader :attach_path, ImageUploader
  validates :user_id, :room_id, :body, :presence => true

end
