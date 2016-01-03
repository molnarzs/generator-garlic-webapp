angular = require 'angular'
require 'angular-mocks'

testContext = require.context('../..', true, /unit-tests.coffee$/)
testContext.keys().forEach(testContext)
