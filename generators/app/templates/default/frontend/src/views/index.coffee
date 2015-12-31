config = require '../config'

Module = angular.module "#{config.MainModuleName}.views", [
  require 'angular-ui-router'
]
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise "/"

  $stateProvider
  .state 'index',
    url: '/'
    views:
      'header':
        template: '<div gt-main-header />'
      'main':
        template: '<div gt-front-page></div>'
]
.directive 'gtFrontPage', require './front-page/'

module.exports = Module.name
