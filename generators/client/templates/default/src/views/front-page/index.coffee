Module = angular.module "#{config.MainModuleName}.views.front-page", []
.directive _.camelCase("#{config.MainModuleName}-front-page"), require './directive'

module.exports = Module.name
