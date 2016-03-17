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
  require './translations'
]
# .config ['$mdThemingProvider', ($mdThemingProvider) ->
#   $mdThemingProvider.theme('<%= appName %>')
#     .primaryPalette 'blue-grey',
#       'hue-1': '900'
#     .accentPalette('purple')
#     .warnPalette('deep-orange')

#   $mdThemingProvider.setDefaultTheme '<%= appName %>'
# ]

module.exports = Module.name