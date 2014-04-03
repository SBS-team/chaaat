Feature: users
  I check registration and authorisation

  Scenario: signing up
    Given homepage
    When I click the 'Sign up' link
    And fill the sign up form
    And I wait 2 seconds
    And click the 'Sign up' button
    And I wait 2 seconds
    And I should be logged in

  Scenario: signing in
    Given an anonymous user
    When I click the 'Login' link
    And fill the sign in form
    And I wait 2 seconds
    And click the 'Log in' button
    And I wait 2 seconds
    And I should be logged in

  Scenario: signing out
    Given a logged in user
    And I wait 2 seconds
    When I click the 'drop1' link
    And I wait 2 seconds
    And I should be logged out