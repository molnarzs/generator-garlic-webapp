# Directive: <%= conf.appNameFQ %>-test-page

Module = angular.module "<%= conf.angularModuleName %>/Views/TestPage", []
.directive "<%= conf.appNameFQcC %>TestPage", require './directive'
.controller "<%= conf.angularModuleName %>/Views/TestPage/Controller", require './controller'

module.exports = Module.name
