Module = angular.module "<%= moduleNameFQ %>", []
.directive "<%= directiveNameCC %>", require './directive'

module.exports = Module.name