Before do
  User.create :login =>'user',:firstname=> 'User_firstname', :lastname=>"User_lastname", :email => 'user@example.com', :password => '12345678abc', :password_confirmation => '12345678abc'
end


Given /^homepage$/ do
  visit '/'
end

When /^fill the sign up form$/ do
  fill_in 'Login', :with =>'user1'
  fill_in 'Firstname', :with =>'User'
  fill_in 'Lastname', :with =>'Userovich'
  fill_in 'Email', :with => 'newuser@example.com'
  fill_in 'Password', :with => '12345678'
  fill_in 'Password confirmation', :with => '12345678'
end

When /^click '(.+)' button$/ do |button|
  click_button button
end

When /^I click '(.+)' button$/ do |button|
  click_button button
end

When /^click the '(.+)' button$/ do |button|
  click_button button
end

When /^I click the '(.+)' button$/ do |button|
  click_button button
end

Then /^I should be logged in$/ do
  uri = URI.parse(current_url)
  "#{uri.path}#{uri.query}".should == rooms_path
end

When /^click '(.+)' link$/ do |link|
  click_link link
end

When /^I click '(.+)' link$/ do |link|
  click_link link
end

When /^click the '(.+)' link$/ do |link|
  click_link link
end

When /^I click the '(.+)' link$/ do |link|
  click_link link
end

When /^fill the sign in form$/ do
  fill_in 'Email', :with => 'user@example.com'
  fill_in 'Password', :with => '12345678abc'
end

When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end

Given /^a logged in user$/ do
  visit '/'
  click_link 'Login'
  fill_in 'Email', :with => 'user@example.com'
  fill_in 'Password', :with => '12345678abc'
  click_button 'Log in'
end

Given /^an anonymous user$/ do

  visit '/'

end


Then /^I should be logged out$/ do
  prev_path = current_path
  visit '/'
  (has_link? 'Logout').should == false
  visit prev_path
end