Firebase = require 'firebase'
q = require 'q'
config = require('../config').config
firebaseRef = config.firebaseRef

module.exports =
  deletePasswordAccount: (email, password) ->
    q.promise (resolve, reject) ->
      fb = new Firebase firebaseRef
      fb.removeUser
        email: email
        password: password
      , (error) ->
        resolve()

  createPasswordAccount: (email, password) ->
    q.promise (resolve, reject) ->
      fb = new Firebase firebaseRef
      fb.createUser
        email: email
        password: password
      , ->
        resolve()
