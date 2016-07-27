require './style'

module.exports = ->
  restrict: 'EA'
  template: require './ui'
  controller: '<%= conf.angularModuleName %>/MainHeader/Controller'
