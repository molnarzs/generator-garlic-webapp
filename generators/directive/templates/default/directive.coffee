<%- c.directiveHeader %>
module.exports = ->
  restrict: 'EA'
  scope: true
  bindToController: true
  #require: ['^ngModel']
  priority: 0
  replace: false
  transclude: false
  <%- c.directiveTemplate %>
  controller: "<%- c.moduleName %>.Controller"
  controllerAs: "ctrl"
