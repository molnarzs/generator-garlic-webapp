Module = angular.module "#{config.MainModuleName}.main-header", []
.directive _.camelCase("#{config.MainModuleName}-main-header"), require './directive'

module.exports = Module.name
