Feature: Edit User
  As a registered user of the website
  I want to edit my account settings
  so I can change my username

    Scenario: I sign in and edit my account
      Given I am logged in
       When I edit my account settings
       Then I should see an account edited message
