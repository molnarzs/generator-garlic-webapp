# Factory name: <%= c.factoryNameFQ %>

Module = angular.module "<%= c.moduleName %>", []
.factory "<%= c.factoryNameFQ %>", require './factory'

module.exports = Module.name