require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
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


end

