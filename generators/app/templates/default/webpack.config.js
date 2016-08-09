config = require('garlictech-workflows-client/dist/webpack/config')(__dirname);
require('./webpack.common.config')(config);
module.exports = config;