require 'spec_helper'

describe FriendshipsController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

end
