# Factory name: <%= factoryNameFQ %>

Module = angular.module "#{config.MainModuleName}.<%= factoryName %>", []
.factory "#{config.MainModuleName}<%= factoryName %>", require './factory'

module.exports = Module.name