require 'spec_helper'

describe FriendshipsController do
  u = User.new( id: "2", login: "petro", encrypted_password: "123456789", firstname: "Example", lastname: "User", email: "user@example.com", user_status: "Available")
  let(:user) { FactoryGirl.create(:user) }
  let(:friendship) { FactoryGirl.create(:friendship) }

  before { sign_in user }
  describe "create friend" do
    it "should be success" do
      response.should be_success
    end
    it "should be redirect" do
      response.should_not be_redirect
    end
    it "has a 200 status code" do
      expect(response.status).to eq(200)
    end
    it "has a 200 status code" do
      delete :destroy, :user_id => user, :friend_id => u, :id => friendship
      expect(response.status).to eq(200)
    end
  end
end
