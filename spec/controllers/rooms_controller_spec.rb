require 'spec_helper'
describe RoomsController do


  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user
  @room = FactoryGirl.create(:room).attributes
  }
  it "should not save room" do
    room = Room.new
    assert !room.save
  end
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    it "renders the show template" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
  def do_create
    post :create, :room => FactoryGirl.build(:room).attributes
  end
  it "should be redirect" do
    do_create
    response.should be_redirect
  end
  it "should be success" do
    do_create
    response.should_not be_success
  end
  it "should be redirect" do
    do_create
    response.should redirect_to(rooms_path)
  end


  it "room create" do
    expect {
      post :create, :room => FactoryGirl.build(:room).attributes
    }.to change(Room, :count).by(1)
  end
end
