GLOBAL.chai = require 'chai'
GLOBAL.chaiAsPromised = require 'chai-as-promised'
GLOBAL.chai.use chaiAsPromised
GLOBAL.expect = chai.expect
GLOBAL.should = chai.should()

globalConfig =
  baseUrl: 'http://localhost:8081'

exports.config = 
  seleniumAddress: 'http://localhost:4444/wd/hub'
  baseUrl: globalConfig.baseUrl
  specs: ['./scenarios/*.scenarios.coffee']

  framework: 'mocha'

  mochaOpts:
    reporter: "spec"
    slow: 3000

  capabilities:
    browserName: 'chrome'
    chromeOptions:
      args: ['lang=en-US']
      prefs:
        intl: { accept_languages: "en-US" }

  onPrepare: ->
    global.EC = protractor.ExpectedConditions
    global.PTR = browser
    global.config = globalConfig
