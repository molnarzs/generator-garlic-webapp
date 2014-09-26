Feature: Cucumber support feature
  As a developer of drywall
  I want to be able to test drywall with cucumber
  So that I can concentrate on building robust applications :)

  Scenario: Load home page
    When I go to the home page
    Then I should see "MEAN - FullStack JS - Development - MEAN - FullStack JS - Development" as the page title
