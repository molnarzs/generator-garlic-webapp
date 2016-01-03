require "file?name=[name].[ext]!./assets/icons/favicon.ico"
require "expose?config!./config"
require './vendor'
require './translations'

Module = angular.module config.MainModuleName, [
  require 'gt-complib'
  require 'gt-complib/src/localize'
  require './views'
  require './footer'
  require './main-header'
  require './ui-modules'
  require './service-modules'
  require './factory-modules'
]
.config ['$mdThemingProvider', ($mdThemingProvider) ->
  $mdThemingProvider.theme('<%= appName %>')
    .primaryPalette 'blue-grey',
      'hue-1': '900'
    .accentPalette('purple')
    .warnPalette('deep-orange')

  $mdThemingProvider.setDefaultTheme '<%= appName %>'
]

module.exports = Module.name