require 'spec_helper'

describe FriendshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, id: "1", login: "petro1", password: "123456789", password_confirmation: "123456789", firstname: "Example1", lastname: "User1", email: "user@example1.com") }

  let(:friendship) { FactoryGirl.create(:friendship) }

  before { sign_in user2 }
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
      delete :destroy, :id=> friendship, :user_id => user, :friend_id => user2
      expect(response.status).to eq(200)
    end
    it "has a 200 status code" do
      post :create, :id=> friendship, :user_id => user, :friend_id => user2
      expect(response.status).to eq(200)
    end
    it "has a 200 status code" do
      post :create, :id=> friendship, :user_id => user, :friend_id => nil
      expect(response.status).to eq(200)
    end
  end
end
