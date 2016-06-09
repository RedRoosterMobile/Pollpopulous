Feature:
  Create a poll and vote
  Test functionality

  @javascript
  Scenario: Create a new poll
    Given I am on the home page
    And I create a new poll
    Then I'm redirected to the poll page
    When I enter my nickname "nick name"
    And I add an option "option name"
    And I add an option "option name"
    Then there is still only one option
    And I vote for "option name"
    Then I see one star
    When I revoke vote for "option name"
    Then I see no stars
    When I revoke vote for "option name"
    Then I see no stars

  @javascript
  Scenario: Revoke vote by non owner
    Given There is a poll set up
    And Someone has voted on a candiate
    And I go to the poll url
    Then I see one star
    When I enter my nickname "nick name"
    And I vote for "option name2"
    Then I see "2" stars
    When I revoke vote for "option name2"
    Then I see one star
    When I revoke vote for "option name2"
    Then I see one star
    And I clean up for coverage

  Scenario: Admin Behavior
    Given There is a poll set up
    And Someone has voted on a candiate
    And I go to the poll page
    Then I should get a "401"
    And I go to the poll page with a token
    Then I should get a "200"
    When I update the existing poll
    Then it should be updated
    When I click back
    And I click destroy and confirm
    Then There should be no polls in database


