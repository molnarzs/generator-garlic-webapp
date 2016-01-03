require './style'

module.exports = ['$log', '$q', ($log, $q) ->
  restrict: 'EA'
  #require: ['^ngModel']
  scope: true
  priority: 0
  replace: false
  transclude: false
  template: require './ui'
  controllerAs: 'ctrl'

  # compile: (tElement, tAttrs, transclude) ->
  #   ($scope, $element, $attrs, ctrls) ->
      
  link: ($scope, $element, $attrs, ctrls) ->
    
  controller: ($scope, $element, $attrs, $transclude) ->
]
