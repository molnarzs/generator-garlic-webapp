module.exports = ['$log', '$q', ($log, $q) ->
  class <%= c.serviceName %>
    { getter, setter } = require('@garlictech/complib/common/src/gs') @
    
    constructor: ->

  return new <%= c.serviceName %>()
]