Given(/^I visit the "([^"]*)" page$/) do |page|
  visit page
end
When /^fill the create room form$/ do
  fill_in 'name', :with =>'room1'
  fill_in 'topic', :with =>'topic1'
end
Then /^I have to get a new room$/ do
  (has_link? 'Room: room1').should == true
end