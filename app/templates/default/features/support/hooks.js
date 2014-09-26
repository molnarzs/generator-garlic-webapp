module.exports = function() {
  return this.Before(function(next) {
    console.log('');
    console.log('************************************');
    console.log("Testing with " + process.env.DRYWALL_TEST_BROWSER);
    console.log('************************************');
    console.log('');
    return next();
  });
};
