# Directive: <%= conf.appNameFQ %>-footer

Module = angular.module "<%= conf.appNameFQcC %>/Footer", []
.directive "<%= conf.appNameFQcC %>Footer", require './directive'
.controller "<%= conf.angularModuleName %>/Footer/Controller", require './controller'

module.exports = Module.name
