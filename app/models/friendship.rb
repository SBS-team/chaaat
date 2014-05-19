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

class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates :user_id, :uniqueness => {:scope => :friend_id}

  after_create do
    Friendship.create(user_id: friend_id, friend_id: user_id)
  end

  scope :find_and_destroy, -> (friend_id, user_id) {
        where('(friend_id = ? AND user_id = ?) OR (friend_id = ? AND user_id = ?)', friend_id, user_id, user_id, friend_id).destroy_all}

end
