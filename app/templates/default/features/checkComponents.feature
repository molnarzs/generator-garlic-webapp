Feature: Components must be running
  As a developer of a garlic web app
  I want to be able to see if all the components are running
  So that I can concentrate on building robust applications :)

  Scenario: Load starting pages
    When I go to the webapp home page
    Then I should see "Garlic Webapp" as the page title
    When I go to the garlic-user home page
    Then I should see "Garlic User is Running" as the page title
