require './style'

module.exports = ->
  restrict: 'EA'
  scope: true
  bindToController: true
  #require: ['^ngModel']
  priority: 0
  replace: false
  transclude: false
  template: require './ui'
  controller: "<%= c.moduleName %>.Controller"
  controllerAs: "ctrl"
