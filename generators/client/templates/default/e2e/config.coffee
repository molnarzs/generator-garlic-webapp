path = require 'path'
require('app-module-path').addPath(path.join process.env.WORKFLOWS_ROOT, 'node_modules') 

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
    chai = require 'chai'
    chaiAsPromised = require 'chai-as-promised'
    chai.use chaiAsPromised
    global.chai = chai
    global.expect = chai.expect
    global.should = chai.should()
