# Directive: <%= conf.appNameFQ %>-test-view

Module = angular.module "<%= conf.angularModuleName %>.Views.TestView", []
.directive "<%= conf.appNameFQcC %>TestView", require './directive'
.controller "<%= conf.angularModuleName %>.Views.TestView.Controller", require './controller'

module.exports = Module.name
