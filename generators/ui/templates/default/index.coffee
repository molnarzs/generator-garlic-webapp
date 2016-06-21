# Directive: <%= c.directiveNameKC %>

Module = angular.module "<%= c.moduleNameFQ %>", []
.directive "<%= c.directiveNameCC %>", require './directive'
.controller "<%= c.moduleNameFQ %>_Controller", require './controller'

module.exports = Module.name