require './style'

module.exports = ->
  restrict: 'EA'
  template: require './ui'
  transclude: true
  controller: '<%= conf.angularModuleName %>/Footer/Controller'