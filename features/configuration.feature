Feature: Configuration File Settings
  In order to create a flexible solution
  I want people to be able to change behavior through configuration

  Scenario: Custom configuration file
    Given no configuration file specified
    Then the project id is 707539

    Given I specify the "pretty_face" configuration file
    Then the project id is 727223

  Scenario: WIP entry in configuration file
    Given no WIP entry in the configuration file
    When I filter for WIP
    Then the count should not include rejected stories
    And the points should not include rejected stories

    Given a WIP includes rejected entry in the configuration file
    When I filter for WIP
    Then the count should include rejected stories

    Given a WIP not includes rejected entry in the configuration file
    When I filter for WIP
    Then the points should not include rejected stories
