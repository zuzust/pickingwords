@contact
Feature: Contact Pickingwords
  As a user of the app
  I want to contact the developers
  So that I can point out issues, bugs or improvements

Background: Contact Page
  Given I am on the Contact page

Scenario Outline: Contact with invalid params
   When I submit the Contact form with '<name>', '<email>', '<subject>' and '<body>' values
   Then I should remain on the Contact page
    And I should see the following error messages: <errors>

  Examples:
    | name | email            | subject | body | errors                 |
    |      | user@example.com | foo     | bar  | missing name           |
    | user |                  | foo     | bar  | missing email          |
    | user | in&valid@format  | foo     | bar  | email format not valid |
    | user | user@example.com | foo     |      | missing body           |

# Scenario: Contact with valid params
#    When I submit the Contact form with 'user', 'user@example.com', 'foo' and 'bar' values
#    Then a message from 'User <user@example.com>', with subject 'foo' and body 'bar' should be delivered
#     And I should remain on the Contact page
#     And I should see a message successfully delivered message
#     And the Contact form fields should be cleared
