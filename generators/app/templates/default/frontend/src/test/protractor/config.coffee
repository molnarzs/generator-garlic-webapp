exports.config = 
  seleniumAddress: 'http://localhost:4444/wd/hub'
  baseUrl: 'http://localhost:8081'
  specs: ['./scenarios/*.scenarios.coffee']
  firebaseRef: 'https://gtrack.firebaseio.com/test'

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
