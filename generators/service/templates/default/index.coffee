# Service name: <%= c.serviceNameFQ %>

Module = angular.module "<%= c.moduleName %>", []
.service "<%= c.serviceNameFQ %>", require './service'

module.exports = Module.name