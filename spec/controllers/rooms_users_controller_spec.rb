require 'spec_helper'

describe RoomsUsersController do

  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room) }

  let(:rooms_user) { FactoryGirl.create(:rooms_user, :user_id => user.id, :room_id => room.id) }

  before { sign_in user  }
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
  it "delete" do
    #Pusher['status'].should_receive(:trigger).with('delete_room', :room_id => room.id).and_return(true)
    #
    #
    #Pusher["private-#{room.id}"].should_receive(:trigger_async).with('del_user_from_room', {:user_login => user.login,
    #                                                                  :drop_user_id => user.id,
    #                                                                  :room_name=>room.name,
    #                                                                  :room_id => room.id})
    #Pusher["private-#{user.id}"].should_receive(:trigger_async).with('private_del_user_from_room', {:room_id => room.id,
    #                                                                                   :rooms_name => room.name})
    delete :destroy,  :room_id => "1", :user_id => "129"
    response.should be_success
  end
end
