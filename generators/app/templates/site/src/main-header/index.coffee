# Directive: <%= conf.appNameFQ %>-main-header

Module = angular.module "<%= conf.appNameFQcC %>/MainHeader", []
.directive "<%= conf.appNameFQcC %>MainHeader", require './directive'
.controller "<%= conf.angularModuleName %>/MainHeader/Controller", require './controller'

module.exports = Module.name
