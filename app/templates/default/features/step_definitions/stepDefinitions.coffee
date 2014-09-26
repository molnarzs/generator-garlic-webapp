port = 3000 # TODO: get it from config
assert = require 'assert'

module.exports = ->
  @World = require("../support/world").World

  @When /^I go to the home page$/, (next) ->
    @visit "http://localhost:#{port}", next

  @Then /^I should see "([^"]*)" as the page title$/, (requiredTitle, next) ->
    @getTitle (returnedTitle) ->
      assert.equal(requiredTitle, returnedTitle)
      next()


