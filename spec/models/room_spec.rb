# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  topic      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'spec_helper'

describe Room do
  context 'Room db columns' do
    it { should have_db_column(:name).of_type(:string)}
    it { should have_db_column(:topic).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime)}
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'Room relationship' do
    it { should have_many(:message) }
    it { should have_many(:rooms_users) }
  end
end
