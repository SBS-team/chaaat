require 'spec_helper'

describe RoomsUser do
  context 'RoomsUser db columns' do
    it { should have_db_column(:user_id).of_type(:integer)}
    it { should have_db_column(:room_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime)}
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'RoomsUser relationship' do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end
end