module.exports = ['$log', '$q', ($log, $q) ->
  class <%= c.factoryName %>
    { getter, setter } = require('@garlictech/complib/common/gs') @
    constructor: ->

  return <%= c.factoryName %>
]