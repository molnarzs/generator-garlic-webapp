Module = angular.module "#{config.MainModuleName}.footer", []
.directive _.camelCase("#{config.MainModuleName}-footer"), require './directive'

module.exports = Module.name
