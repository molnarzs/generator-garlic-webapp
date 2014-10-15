'use strict'
module.exports = ->
  @Before (next) ->
    console.log('')
    console.log('************************************')
    console.log("Testing with #{process.env.DRYWALL_TEST_BROWSER}")
    console.log('************************************')
    console.log('')
    next()
