require 'spec_helper'

describe Friendship do
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
end
