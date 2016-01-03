Module = angular.module "#{config.MainModuleName}.<%= moduleNameCC %>", []
.directive _.camelCase("#{config.MainModuleName}-<%= moduleName %>"), require './directive'

module.exports = Module.name