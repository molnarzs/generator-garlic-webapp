# Factory name: <%= c.factoryNameFQ %>

Module = angular.module "<%= c.moduleName %>", []
.factory "<%= c.serviceNameFQ %>", require './factory'

module.exports = Module.name