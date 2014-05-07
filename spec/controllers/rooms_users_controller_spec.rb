require 'spec_helper'

describe RoomsUsersController do

  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room, :user_id => user.id) }

  let(:rooms_user) { FactoryGirl.create(:rooms_user, :user_id => user.id, :room_id => room.id) }

  before { sign_in user }
  it "should not save room" do
    room = Room.new
    assert !room.save
  end
  it "should be success" do
    response.should be_success
  end
  it "should be redirect" do
    response.should_not be_redirect
  end
  it "create" do
    post :create, :room_id => rooms_user, :user_id => user
    response.should be_success
  end
  it "delete" do
    delete :destroy, :room_id => room, :user_id => user, :id => rooms_user
    response.should be_success
  end
end