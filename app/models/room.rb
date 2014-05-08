# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  topic      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  creator_id :integer
#

class Room < ActiveRecord::Base

  has_many :messages, dependent: :destroy
  has_many :rooms_users, dependent: :destroy
  has_many :users, through: :rooms_users

  belongs_to :creator, foreign_key: :creator_id, class_name: 'User'

  validates :name, length: 1..100, presence: true
  validates :topic, length: 0..20, presence: true

  def create_rooms_user_object( id )
    self.rooms_users.create( user_id: id )
  end

end
