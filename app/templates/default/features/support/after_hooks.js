module.exports = function() {
  return this.After(function(next) {
    this.browser.end();
    return next();
  });
};
