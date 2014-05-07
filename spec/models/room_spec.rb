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
  before do
    @room = FactoryGirl.create(:room, :user_id => "1")
  end
  subject { @room }
  context 'Room db columns' do
    it { should have_db_column(:name).of_type(:string)}
    it { should have_db_column(:topic).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime)}
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'Room relationship' do
    it { should have_many(:rooms_users) }
  end
  it { should respond_to(:name) }
  it { should respond_to(:topic) }

  describe "when name is not present" do
    before { @room.name = "" }
    it { should_not be_valid }
  end
  describe "when name is too long" do
    before { @room.name = "a" * 151 }
    it { should_not be_valid }
  end
  describe "when topic is too long" do
    before { @room.topic = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when topic is too long" do
    before { @room.topic = ""}
    it { should_not be_valid }
  end
end
