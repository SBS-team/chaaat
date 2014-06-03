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

  validates :creator_id, :presence => true
  validates :name, length: 1..20, presence: true
  validates :topic, length: 0..20, presence: true
  validate :limit_room, :on => :create, :message => "must be provided"

  def create_rooms_user_object( id )
    self.rooms_users.create( user_id: id )
  end
  def limit_room
    limit = User.find(Thread.current['current_user'].id).rooms.count
    if limit >= 3
      errors.add(:limit_room, "You can create 3 rooms")
    end
  end
end
