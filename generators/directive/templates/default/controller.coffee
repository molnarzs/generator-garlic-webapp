module.exports = [
  '$q', '$log',
  '$scope', '$rootScope',
  '$state', '$stateParams',
  ($q, $log, $scope, $rootScope, $state, $stateParams) ->
    Parent = this

    class Controller
      constructor: ->
        # Pull in the attributes from "bindToController". They are bound to the external function.
        _.assign @, Parent

    return new Controller()
]
