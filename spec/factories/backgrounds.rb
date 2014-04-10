# == Schema Information
#
# Table name: backgrounds
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  path       :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :background do
  end
end
