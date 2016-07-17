require('garlictech-workflows-client/dist/test/unit');

var testContext = require.context('../..', true, /unit-tests\..*$/);
testContext.keys().forEach(testContext);
