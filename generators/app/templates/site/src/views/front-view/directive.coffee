require './style'

module.exports = ->
  restrict: 'AE'
  template: require './ui.jade'
  controller: '<%= conf.angularModuleName %>.Views.FrontView.Controller'