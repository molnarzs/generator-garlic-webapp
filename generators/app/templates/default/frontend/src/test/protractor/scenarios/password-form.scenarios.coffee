# chai = require 'chai'
# chaiAsPromised = require 'chai-as-promised'
# chai.use chaiAsPromised
# expect = chai.expect
# should = chai.should()
# config = require('../config').config
# assertions = require '../support/assertions'
# PasswordForm = require '../pages/password_form'

# describe "Test password form", ->
#   passwordForm = new PasswordForm
#   validPassword = "12345678"
#   otherValidPassword = "87654321"
#   shortPassword = "1234"

#   beforeEach ->
#     passwordForm.getPage()

#   describe "When user first writes password confirmation, then password", ->
#     it "should result valid password form", ->
#       passwordForm.setPasswordConfirmation(validPassword).should.eventually.resolve
#       passwordForm.setPassword(validPassword).should.eventually.resolve

#       passwordForm.passwordConfirmationError.getText().should.eventually.equal ''

#   describe "When user first writes password, then password confirmation", ->
#     it "should result valid password form", ->
#       passwordForm.setPassword(validPassword).should.eventually.resolve
#       passwordForm.setPasswordConfirmation(validPassword).should.eventually.resolve

#       passwordForm.passwordConfirmationError.getText().should.eventually.equal ''