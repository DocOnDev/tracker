Feature: Harvester harvests project data from json file
  In order to analyze project data
  I want to be be able to read project data from a json file

  Scenario: json file is not the correct format
    Given I have an invalid json file
    Then I receive an error message on parse of file

  @focus
  Scenario: json file is correct format
    Given I have a valid json file with four stories
    When I read that file
    Then the result should include four elements
    And the first element should be a story
