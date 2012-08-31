@search
Feature: Search for picked word
  As an active picker
  I want to be able to search for my picked words
  So that I can quickly recall their translation

Background: Logged in
  Given I am logged in
    And just the following filters are applied: fav, EN
    And I picked the following words:
      | name      | translation | from_lang | to_lang | fav   |
      | astounded | sorprès     | en        | ca      | false |
      | back up   | recolzar    | en        | ca      | false |
      | clutter   | desordre    | en        | ca      | true  |
      | excerpt   | fragment    | en        | ca      | true  |
      | paraula   | word        | ca        | en      | false |

Scenario Outline: Search with invalid params
   When I look for pick '<word>' from '<source_locale>' to '<target_locale>'
   Then I should remain on my home page
    And just the following filters should be applied: fav, EN
    And I should see the following error messages: <errors>

  Examples:
    | word      | source_locale | target_locale | errors                                       |
    |           | en            |               | missing name                                 |
    | 8tjdi     |               | ca            | invalid name                                 |
    | foo       | en            | en            | same source and target locales               |
    | 8tjdi     | ca            | ca            | invalid name, same source and target locales |

Scenario Outline: Search for nonexistent pick
   When I look for nonexistent pick '<word>' from '<source_locale>' to '<target_locale>'
   Then I should remain on my home page
    And I should see a nothing to show message

  Examples:
    | word      | source_locale | target_locale |
    | foo       |               |               |
    | clutter   | es            |               |
    | excerpt   |               | en            |

Scenario Outline: Search for existing pick
   When I look for existing pick '<word>' from '<source_locale>' to '<target_locale>'
   Then I should remain on my home page
    And I should only see the pick '<word>' listed

  Examples:
    | word      | source_locale | target_locale |
    | astounded |               |               |
    | back up   | en            |               |
    | clutter   |               | ca            |
    | excerpt   | en            | ca            |
    | paraula   | ca            |               |
