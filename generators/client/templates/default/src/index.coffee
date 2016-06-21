require "file?name=[name].[ext]!./assets/icons/favicon.ico"
require './globals'
require './vendor'
require './style'

Module = angular.module config.MainModuleName, [
  # 'ngMaterial'
  # 'ngSanitize'
  # 'ngAnimate'
  require '@garlictech/complib/frontend/src/localize'
  require './views'
  require './footer'
  require './main-header'
  require './ui-modules'
  require './service-modules'
  require './factory-modules'
  require './provider-modules'
  require './translations'
]

module.exports = Module.name