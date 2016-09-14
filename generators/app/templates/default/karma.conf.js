webpackConfig = require('garlictech-workflows-client/dist/webpack/config')(__dirname);
require('./webpack.common.config')(webpackConfig);
module.exports = require('garlictech-workflows-client/dist/webpack/karma')(__dirname, webpackConfig);