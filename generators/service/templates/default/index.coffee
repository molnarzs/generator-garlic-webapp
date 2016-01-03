# Service name: <%= serviceNameFQ %>

Module = angular.module "#{config.MainModuleName}.<%= serviceName %>", []
.service "#{config.MainModuleName}<%= serviceName %>", require './service'

module.exports = Module.name