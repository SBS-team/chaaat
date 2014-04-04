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


require 'spec_helper'

describe Friendship do
  before do
    @friendship = Friendship.new(user_id: "1")
  end
  subject { @friendship }
  context 'Friendship db columns' do
    it { should have_db_column(:user_id).of_type(:integer)}
    it { should have_db_column(:friend_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime)}
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'Friendship relationship' do
    it { should belong_to(:user) }
    it { should belong_to(:friend) }
  end
  it { should respond_to(:user_id) }


end
