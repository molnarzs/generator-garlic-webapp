module.exports = ['$log', '$q', ($log, $q) ->
  class <%= c.factoryName %>
    { getter, setter } = require('gt-complib/common/src/gs') @
    constructor: ->

  return <%= c.factoryName %>
]