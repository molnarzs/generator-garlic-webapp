Feature: Cucumber support feature
  As a developer of a garlic web app
  I want to be able to see if all the components are running
  So that I can concentrate on building robust applications :)

  Scenario: Load startng pages
    When I go to the webapp home page
    Then I should see "MEAN - FullStack JS - Development - MEAN - FullStack JS - Development" as the page title
    When I go to the garlic-user home page
    Then I should see "MEAN - FullStack JS - Development - MEAN - FullStack JS - Development" as the page title
