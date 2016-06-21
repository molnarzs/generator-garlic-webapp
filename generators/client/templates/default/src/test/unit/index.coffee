module.exports = require '../'

angular.extend module.exports, 
  getCompiledElement: (html) ->
    E = {}
    beforeEach inject ($rootScope, $compile) ->
      E.scope = $rootScope.$new()
      element = angular.element html
      E.template = $compile(element)(E.scope)
      E.scope.$digest()
      return
    return E

