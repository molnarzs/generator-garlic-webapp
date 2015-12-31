q = require 'q'

class PasswordForm
  constructor: ->
    @passwordField = $('gt-password-form').$('[gt-name="passwordField"]')
    @passwordInput = @passwordField.$ 'input'
    @passwordError = @passwordField.$('gt-error-field').$('div')
    @passwordConfirmationField = $('gt-password-form').$('[gt-name="passwordCompareField"]')
    @passwordConfirmationInput = @passwordConfirmationField.$ 'input'
    @passwordConfirmationError = @passwordConfirmationField.$('gt-error-field').$('div')
    @url = '/#/register'

  getPage: ->
    browser.get @url

  setPassword: (val) ->
    @passwordInput.sendKeys val 

  setPasswordConfirmation: (val) ->
    @passwordConfirmationInput.sendKeys val

module.exports = PasswordForm