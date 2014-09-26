module.exports = ->
  @After (next) ->
    @browser.end()
    next()
