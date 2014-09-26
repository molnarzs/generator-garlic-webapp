webdriverio = require 'webdriverio'

module.exports.World = World = (next) ->
  @browser = webdriverio.remote({ desiredCapabilities: {
    browserName: process.env.DRYWALL_TEST_BROWSER
    "phantomjs.binary.path": "node_modules/phantomjs/bin/phantomjs"
  }})
    .init()

  @visit = (url, next) ->
    @browser.url url
      .call(next)

  @getTitle = (next) ->
    @browser.getTitle (err, title) ->
      next(title)

  next()
