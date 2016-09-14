module.exports = ['$q', '$log', '$firebaseObject', '$firebaseArray', ($q, $log, $firebaseObject, $firebaseArray) ->
  class <%= c.serviceName %>
    constructor: ->
      config =
        apiKey: "<%= c.apiKey %>"
        authDomain: "<%= c.authDomain %>"
        databaseURL: "<%= c.databaseURL %>"
        storageBucket: "<%= c.storageBucket %>"

      app = firebase.initializeApp config
      @_db = app.database()


    handleError: (error) ->
      if error?.code in ["INVALID_USER", "NETWORK_ERROR", "USER_DENIED", "PERMISSION_DENIED"]
        return Error error.code
      else if error?.message
        return Error error.message
      else
        return Error 'UNKNOWN_ERROR'

    execute: (promise) ->
      promise.catch (error) =>
        $log.debug error
        $q.reject @handleError error

    # TODO Not unit tested, fucking mockfirebase returned weird error.
    getObjRef: (objId) ->
      @_db.ref objId

    getObj: (objId) ->
      ref = @getObjRef objId
      @execute $firebaseObject(ref).$loaded()

    getArray: (objId) ->
      ref = @getObjRef objId
      @execute $firebaseArray(ref).$loaded()

    bindTo: (objId, scope, scopeKey) ->
      ref = @getObjRef objId
      $firebaseObject(ref).$bindTo scope, scopeKey

    @timestamp = ->
      Firebase.ServerValue.TIMESTAMP

  return new <%= c.serviceName %>()
]