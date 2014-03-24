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



FactoryGirl.define do
  factory :room do
    name "MyString"
    topic "MyString"
  end
end
