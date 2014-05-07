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


require 'file_size_validator'
class Message < ActiveRecord::Base
  require 'carrierwave'
  belongs_to :user
  belongs_to :room
  mount_uploader :attach_path, ImageUploader
  validates :attach_path,
            :file_size => {
                :maximum => 20.megabytes.to_i
            }
  validates  :room_id, :presence => true
  before_save :gsub_message, on: :create

  scope :get_body_links, -> (messages) { messages.where( 'body LIKE ? OR body LIKE ? OR body LIKE ?', '%http://%', '%https://%', '%ftp://%' ) }
  scope :get_body_attach, -> (messages) { messages.where( 'attach_path IS NOT NULL' ) }

  private

  def gsub_message
    self.body.gsub!(/[\n]/,"")
  end

end
