class Room < ActiveRecord::Base
  has_many :message
  has_many :rooms_users

# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  topic      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

end
