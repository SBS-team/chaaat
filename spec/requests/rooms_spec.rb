require 'spec_helper'
describe "Chat pages" do

  subject{
    page
  }
  before :each do
    @user = FactoryGirl.create(:user)
    @room = FactoryGirl.create(:room, :creator_id => @user.id)
    sign_in @user
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  describe "GET /room" do
    it "creates room", :js => true do
      visit rooms_path
      click_on "Create Room"
      fill_in "room_name", :with => "test"
      fill_in "room_topic", :with => "test"
      click_button "Create"
      page.should have_content("test")
      sleep 2.seconds
    end

    it "creates message" do
      visit room_path(1)
      page.should have_content("test")
      fill_in "message", :with => "testing message"
      find(".send_message_button").click
      page.should have_content("testing message")
      sleep 2.seconds
    end


  #  it "messages smile" do
  #    visit rooms_path
  #    click_button "Create Room"
  #    fill_in "room_name", :with => "test"
  #    fill_in "room_topic", :with => "test"
  #    click_button "Create"
  #    page.should have_content("test")
  #    sleep 6.seconds
  #    first(:link, "test").click
  #    fill_in "message", :with => ":smile:"
  #    find(".send_message_button").click
  #    Message.count(+1)
  #    sleep 6.seconds
  #
  #  end
  #end
  #it "persons page" do
  #  visit rooms_path
  #  click_link "Friends"
  #  sleep 6.seconds
  #  page.should have_content("Possible friends")
  #end
  #
  #
  #describe "Status" do
  #  it "user_stat" do
  #    find(".avail").click
  #    first(:find, ".change-status").click
  #    page.should have_content("Available")
  #  end
  #
  #end
  #describe "Delete/Room", :js=>true do
  #  it "user_stat" do
  #    click_button "Create Room"
  #    fill_in "room_name", :with => "test"
  #    fill_in "room_topic", :with => "test"
  #    click_button "Create"
  #    page.should have_content("test")
  #    find(".glyphicon-remove-circle").click
  #    Room.count(-1)
  #    sleep 6.second
  #  end
  end

end