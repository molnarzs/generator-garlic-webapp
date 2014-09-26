var World, webdriverio;

webdriverio = require('webdriverio');

module.exports.World = World = function(next) {
  this.browser = webdriverio.remote({
    desiredCapabilities: {
      browserName: process.env.DRYWALL_TEST_BROWSER,
      "phantomjs.binary.path": "node_modules/phantomjs/bin/phantomjs"
    }
  }).init();
  this.visit = function(url, next) {
    return this.browser.url(url).call(next);
  };
  this.getTitle = function(next) {
    return this.browser.getTitle(function(err, title) {
      return next(title);
    });
  };
  return next();
};
