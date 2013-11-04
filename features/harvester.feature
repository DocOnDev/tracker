@focus
Feature: Harvest Data
  In order to run regular reports
  As a project manager
  I want to harvest data from Pivotal Tracker

  Scenario: Read from text file
    Given I am reading from local text files
    And I am writing to a local text file
    When I harvest the data
    Then I should have 4 stories