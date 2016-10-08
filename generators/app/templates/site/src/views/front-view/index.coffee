# Directive: <%= conf.appNameFQ %>-front-view

Module = angular.module "<%= conf.appNameFQcC %>/views/FrontView", []
.directive "<%= conf.appNameFQcC %>FrontView", require './directive'
.controller "<%= conf.angularModuleName %>.Views.FrontView.Controller", require './controller'

module.exports = Module.name
