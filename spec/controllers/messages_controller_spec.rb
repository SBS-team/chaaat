require 'spec_helper'

describe MessagesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room, :creator_id => user.id ) }

  before { sign_in user
  }
  it "should  save message" do
    response.should be_success
  end

  it "should not save message" do
    message = Message.new
    assert !message.save
  end

  it "should be redirect" do
    response.should_not be_redirect
  end
  it "has a 200 status code" do
    expect(response.status).to eq(200)
  end

  it "message create" do
    expect {
      post :create, :room_id => room, :messages => FactoryGirl.create(:message).attributes, :user_id => user.id
    }.to change(Message, :count).by(1)
    end

  it "message create" do
      get :search, :body => "a"
  end
end