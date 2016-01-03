Module = angular.module "#{config.MainModuleName}.views.test-page", []
.directive _.camelCase("#{config.MainModuleName}-test-page"), require './directive'

module.exports = Module.name
