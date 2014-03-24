require 'spec_helper'

describe MessageController do

  describe "show message" do
    it 'renders show template' do
      body = FactoryGirl.create(:message)
      get :show, {:id=>body.id}
    end
  end

  describe "search message" do
    it 'renders search template' do
      get :search, {:query=>"sd"}
    end
  end

end