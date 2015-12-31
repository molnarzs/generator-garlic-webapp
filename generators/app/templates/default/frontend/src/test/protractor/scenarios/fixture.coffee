Utils = require '../support/utils'

module.exports = 
  existingUser: 
    email: "protractor@test.hu"
    password: "12345678"

  nonExistingUser:
    email: 'bad@a.hu'
    password: '12345678'

before ->
  @timeout 10000
  Utils.createPasswordAccount module.exports.existingUser.email, module.exports.existingUser.password

after ->
  @timeout 10000
  Utils.deletePasswordAccount module.exports.existingUser.email, module.exports.existingUser.password

  Utils.deletePasswordAccount module.exports.nonExistingUser.email, module.exports.nonExistingUser.password