angular = require 'angular'

testContext = require.context('../..', true, /system-tests.coffee$/)
testContext.keys().forEach(testContext)