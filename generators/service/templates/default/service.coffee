module.exports = ['$log', '$q', ($log, $q) ->
  class <%= c.serviceName %>
    { getter, setter } = require('@garlictech/complib/common/gs') @
    
    constructor: ->

  return new <%= c.serviceName %>()
]