module.exports = ->

  $get: ['$log', '$q', ($log, $q) ->
    class <%= c.providerName %>
      constructor: ->

    return new <%= c.providerName %>()
  ]