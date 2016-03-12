module.exports = ['$log', '$q', ($log, $q) ->
  class <%= c.factoryName %>
    { getter, setter } = require('@garlictech/complib/common/src/gs') @
    constructor: ->

  return <%= c.factoryName %>
]