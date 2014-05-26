require 'spec_helper'
describe RoomsController do


  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room, :creator_id=> user.id) }
  let(:rooms_user) { FactoryGirl.create(:rooms_user, :room_id => room.id, :user_id => user.id) }
  let(:message) { FactoryGirl.create(:message) }

  before { sign_in user }
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
  it "renders the index template" do
    get :index
    response.should be_success
    expect(response.status).to eq(200)

  end

  it "room create" do
    expect {
      post :create, :room => FactoryGirl.build(:room).attributes
    }.to change(Room, :count).by(1)
  end

  it "should route index /" do
    {:get => rooms_path}.should route_to(
                                    :controller => "rooms",
                                    :action => "index"
                                )
  end
  it "should route index /" do
    {:get => new_room_path}.should route_to(
                                       :controller => "rooms",
                                       :action => "new"
                                   )
  end
  it "should route show /" do
    {:get => "/rooms/1"}.should route_to("rooms#show", :id => "1")
  end
  describe "DELETE 'destroy'" do
    it 'destroy' do
      delete :destroy, :id => room
      response.should be_success
    end
    it 'destroy' do
      expect { delete :destroy, :id => room
      }.to change(Room, :count).by(0)
    end
    it 'destroy' do
      delete :destroy, :id => room
      room.topic= "bla"
      expect(response.status).to eq(200)
    end
  end
  it "update" do
    @room = FactoryGirl.create(:room, :creator_id => user.id)
    put :update, :id => @room,  :query => "aaa"
    expect(response.status).to eq(200)
  end
  it 'show' do
    get :show, :id => rooms_user
    expect(response.status).to eq(200)
  end
  it 'load_previous_10_msg' do
    get :load_previous_10_msg, :id => rooms_user, :room_id => room.id, :message => message
    expect(response.status).to eq(200)
  end
end