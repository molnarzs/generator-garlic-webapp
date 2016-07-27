# Directive: <%= conf.appNameFQ %>-front-page

Module = angular.module "<%= conf.appNameFQcC %>/views/FrontPage", []
.directive "<%= conf.appNameFQcC %>FrontPage", require './directive'
.controller "<%= conf.angularModuleName %>/Views/FrontPage/Controller", require './controller'

module.exports = Module.name
