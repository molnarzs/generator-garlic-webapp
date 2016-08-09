# Directive: <%= c.directiveNameKC %>

Module = angular.module "<%= c.moduleName %>", []
.directive "<%= c.directiveNameCC %>", require './directive'
.controller "<%= c.moduleName %>.Controller", require './controller'

module.exports = Module.name