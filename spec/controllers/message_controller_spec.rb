require 'spec_helper'

describe MessageController do
  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room) }

  before { sign_in user }
  describe "POST 'create'" do
    it "returns  success" do
      get 'new'
    end
  end


end