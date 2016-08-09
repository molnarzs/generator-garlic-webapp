config = require('garlictech-workflows-client/dist/webpack/karma')(__dirname);
require('./webpack.common.config')(config);
module.exports = config;
