_ = require 'lodash'
fs = require 'fs'
path = require 'path'
commonConfig = require('./webpack-common')

moduleName = JSON.parse(fs.readFileSync('./package.json', 'utf8')).name
PATHS = commonConfig.paths

webpackConf = 
  context: PATHS.src
  entry:
    "#{moduleName}": './index.coffee'
  output:
    path: PATHS.dist
    filename: "[name].min.js"
    sourceMapFilename: "[file].map"

  cache: true

  devServer:
    contentBase: PATHS.src
    content: "index.html"
    hot: true
    colors: true
    port: 8081
    host: '0.0.0.0'


module.exports = _.assign commonConfig.config, webpackConf