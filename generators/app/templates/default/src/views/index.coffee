config = require '../config'

Module = angular.module "<%= conf.angularModuleName %>/views", [
  require 'angular-ui-router'
  require './front-view'
  require './test-view'
  #===== yeoman hook require =====#
  # NB! The above line is required for garlic yeoman generator and should not be changed. Otherwise, you are cursed.
  # If you do not know what garlic is in this context then do whatever you want to do.
]
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise "/"

  $stateProvider
  .state 'index',
    url: '/'
    views:
      'header':
        template: '<div <%= conf.appNameFQ %>-main-header></div>'
      'main':
        template: '<div <%= conf.appNameFQ %>-front-view></div>'

  .state 'test',
    url: '/test'
    views:
      'main':
        template: '<div <%= conf.appNameFQ %>-test-view></div>'

  #===== yeoman hook state =====#
  # NB! The above line is required for garlic yeoman generator and should not be changed. Otherwise, you are cursed.
  # If you do not know what garlic is in this context then do whatever you want to do.
]

module.exports = Module.name
