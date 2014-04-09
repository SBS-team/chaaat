# == Schema Information
#
# Table name: user_stats
#
#  id          :integer          not null, primary key
#  status_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class UserStat < ActiveRecord::Base  #FIXME remove
	has_one :user
end
