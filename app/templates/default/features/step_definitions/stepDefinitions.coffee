'use strict'
webappPort = 9000 # TODO: get it from config
garlicUserPort = 9001 # TODO: get it from config
assert = require 'assert'

module.exports = ->
  @World = require("../support/world").World

  @When /^I go to the webapp home page$/, (callback) ->
    @visit "http://localhost:#{webappPort}", callback

  @When /^I go to the garlic\-user home page$/, (callback) ->
    @visit "http://localhost:#{garlicUserPort}", callback

  @Then /^I should see "([^"]*)" as the page title$/, (requiredTitle, next) ->
    @getTitle (returnedTitle) ->
      assert.equal(requiredTitle, returnedTitle)
      next()
