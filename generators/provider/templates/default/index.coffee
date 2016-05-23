# Provider name: <%= c.providerNameFQ %>

Module = angular.module "<%= c.moduleName %>", []
.provider "<%= c.providerNameFQ %>", require './provider'

module.exports = Module.name