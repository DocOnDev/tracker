Feature: Velocity
  In order to better predict future velocity
  As an interested team member
  I want to know our past velocity

  Scenario: Filters on story labels
    Given no label specified
    Then the velocity includes all stories

    Given the label "heartX" is specified
    Then the velocity includes only "heartX" stories

    Given the labels "heartX" and "heartY" are specified
    Then the velocity includes both "heartX" and "heartY" stories

  @focus
  Scenario: Working with local file
    Given a bogus file
    Then there are 0 velocity records

    Given a valid sample file
    Then there are 4 velocity records

