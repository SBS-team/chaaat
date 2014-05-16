# == Schema Information
#
# Table name: backgrounds
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  path       :text
#

class Background < ActiveRecord::Base
  require 'carrierwave'
  mount_uploader :path, BackgroundUploader
end
