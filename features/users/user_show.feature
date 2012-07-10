Feature: Show User
  As a registered user of the website
  I want to see my account profile
  so I can know my usage stats

    Scenario: I sign in and see my account profile
      Given I am logged in
       When I see my account profile
       Then I should see my usage stats
