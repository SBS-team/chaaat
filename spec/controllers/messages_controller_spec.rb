require 'spec_helper'

describe MessagesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room) }

  before { sign_in user }
  it "should not save message" do
    message = Message.new
    assert !message.save
  end
  it "should not save message" do
    message = Message.new
    assert !message.save
  end

end