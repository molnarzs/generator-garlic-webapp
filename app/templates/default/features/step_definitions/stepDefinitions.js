var assert, port;

port = 3000;

assert = require('assert');

module.exports = function() {
  this.World = require("../support/world").World;
  this.When(/^I go to the home page$/, function(next) {
    return this.visit("http://localhost:" + port, next);
  });
  return this.Then(/^I should see "([^"]*)" as the page title$/, function(requiredTitle, next) {
    return this.getTitle(function(returnedTitle) {
      assert.equal(requiredTitle, returnedTitle);
      return next();
    });
  });
};
