# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  body        :text
#  attach_path :text
#  attach_size :text
#  room_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_messages_on_room_id  (room_id)
#  index_messages_on_user_id  (user_id)
#

require 'spec_helper'

describe Message do
  context 'Message db columns' do
    it { should have_db_column(:user_id).of_type(:integer)}
    it { should have_db_column(:body).of_type(:text) }
    it { should have_db_column(:attach_path).of_type(:text)}
    it { should have_db_column(:attach_size).of_type(:text) }
    it { should have_db_column(:room_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime)}
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'Message relationship' do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end
end
