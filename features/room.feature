Feature: users
  I check room creation

  Scenario: room creation
    Given a logged in user
    Given I visit the "/rooms" page
    And I wait 2 seconds
    And click the 'createRoom' button
    And I wait 4 seconds
    And fill the create room form
    And I wait 2 seconds
    And click the 'Create' button
    And I wait 2 seconds
    And I have to get a new room

    #FIXME remove cucuber and add rspec + capybara