angular = require 'angular'
require 'angular-mocks'

testContext = require.context('../..', true, /tests.coffee$/)
testContext.keys().forEach(testContext)
