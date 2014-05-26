require 'spec_helper'
describe PusherController do
  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room, :creator_id => user.id) }

  before { sign_in user }
  it "auth" do
    get :auth, :room_id => room
    expect(response.status).to eq(403)
  end
  it "renders stat" do
    get :stat, :user_id => user
    expect(response).to be_success
    expect(response.status).to eq(200)
  end
  it "renders stat" do
    get :stat, :user_id => user, :client_status=>'Available'
    expect(response).to be_success
    expect(response.status).to eq(200)
  end
end