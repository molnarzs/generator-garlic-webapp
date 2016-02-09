# Directive: <%= c.directiveNameKC %>

Module = angular.module "<%= c.moduleNameFQ %>", []
.directive "<%= c.directiveNameCC %>", require './directive'

module.exports = Module.name