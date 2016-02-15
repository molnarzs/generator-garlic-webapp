module.exports = ['$log', '$q', ($log, $q) ->
  class <%= c.serviceName %>
    { getter, setter } = require('gt-complib/common/src/gs') @
    
    constructor: ->

  return new <%= c.serviceName %>()
]