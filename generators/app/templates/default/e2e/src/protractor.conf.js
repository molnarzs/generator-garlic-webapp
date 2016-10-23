var globalConfig, path;

path = require('path');

globalConfig = {
  baseUrl: 'http://' + process.env.WEBSERVER_IP + ':8081'
};

exports.config = {
  baseUrl: globalConfig.baseUrl,
  specs: ["/protractor/scenarios/*.scenarios.*"],
  framework: 'mocha',
  mochaOpts: {
    reporter: "spec",
    slow: 3000
  },
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      args: ['--whitelisted-ips="0.0.0.0"']
    }
  },
  onPrepare: function() {
    var chai, chaiAsPromised;
    global.EC = protractor.ExpectedConditions;
    global.PTR = browser;
    global.config = globalConfig;
    chai = require('chai');
    chaiAsPromised = require('chai-as-promised');
    chai.use(chaiAsPromised);
    global.chai = chai;
    global.expect = chai.expect;
    return global.should = chai.should();
  }
};
