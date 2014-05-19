require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room, :creator_id => user.id) }

  before { sign_in user }
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
    it "should not save room" do
      user = User.new
      assert !user.save
    end
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
  it "should be success" do
    response.should be_success
  end
  it "has a 200 status code" do
    expect(response.status).to eq(200)
  end
  it "should be redirect" do
    response.should_not be_redirect
  end
  it "should route index /" do
    { :get => "/persons" }.should route_to(
                                    :controller => "users",
                                    :action => "index"
                                )
  end
  it "search" do
    get :search, :room_id => room, :login => user.login, :user_id => user
    expect(response.status).to eq(200)
  end
  it "search" do
    get :search,  :login => user.login, :user_id => user
    expect(response.status).to eq(200)
  end
  it "renders the index template" do
    get :index, :search => "pe"
    expect(response).to render_template("index")
  end
  it "invite_user" do
    get :invite_user, :email => user.email, :login => user.login
    expect(response.status).to eq(200)
  end
  it "change_status" do
    get :change_status, :status => "Available"
   expect(response.status).to eq(200)
  end
  it "change_status" do
    get :change_status, :status => "Away"
    expect(response.status).to eq(200)
  end
  it "change_status" do
    get :change_status, :status => "Do not disturb"
    expect(response.status).to eq(200)
  end
  it "change_status" do
    get :change_status, :status => "Offline"
    expect(response.status).to eq(200)
  end
  it "change_status" do
    get :change_status, :status => "Help"
    expect(response.status).to eq(200)
  end

end

