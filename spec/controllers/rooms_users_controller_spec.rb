require 'spec_helper'

describe RoomsUsersController do


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

end
