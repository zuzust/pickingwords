@translate
Feature: Translate a word
  As a student of foreign languages
  I want to be able to translate words in other languages
  So that I can improve my vocabulary

Background: Logged in
  Given I am logged in
    And just the following filters are applied: fav, EN
    And I picked the following words:
      | name      | translation | from_lang | to_lang | fav   |
      | astounded | sorprès     | en        | ca      | false |
      | paraula   | word        | ca        | en      | false |

Scenario Outline: Translate with invalid params
   When I translate '<word>' from '<source_locale>' to '<target_locale>'
   Then I should remain on my home page
    And just the following filters should be applied: fav, EN
    And I should see the following error messages: <errors>

  Examples:
    | word      | source_locale | target_locale | errors                                       |
    |           | en            |               | missing name                                 |
    | 8tjdi     |               | ca            | invalid name                                 |
    | foo       | en            | en            | same source and target locales               |
    | 8tjdi     | ca            | ca            | invalid name, same source and target locales |

Scenario Outline: Translate existing pick
   When I translate '<word>' from '<source_locale>' to '<target_locale>'
   Then I should remain on my home page
    And I should only see the pick '<word>' listed

  Examples:
    | word      | source_locale | target_locale |
    | astounded | en            | ca            |
    | paraula   | ca            | en            |

Scenario: Translate not yet picked word
  Given the translation service provides the following translation:
    | text      | from | to | translation |
    | clutter   | en   | ca | desordre    |
   When I translate 'clutter' from 'en' to 'ca'
   Then I should be on the Translated Word page
    And I should see the word 'clutter' and its translation 'desordre'

Scenario: Translate not yet picked word with context
  Given the translation service provides the following translations:
    | text              | from | to | translation             |
    | excerpt           | en   | ca | fragment                |
    | read this excerpt | en   | ca | llegeix aquest fragment |
   When I translate 'excerpt' from 'en' to 'ca' with context 'read this excerpt'
   Then I should be on the Translated Word page
    And I should see the word 'excerpt' and its translation 'fragment'
    And I should see the context 'read this excerpt' and its translation 'llegeix aquest fragment'

Scenario: Service provider not responding
  Given the translation service does not respond
   When I translate 'clutter' from 'en' to 'ca'
   Then I should remain on my home page
    And I should see a service provider not responding message

