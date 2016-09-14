# Service name: <%= c.serviceNameFQ %>

Module = angular.module "<%= c.moduleName %>", [
  'firebase'
]
.service "<%= c.serviceNameFQ %>", require './service'

module.exports = Module.name