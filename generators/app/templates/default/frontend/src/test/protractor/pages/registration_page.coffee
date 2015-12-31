q = require 'q'
config = require('../config').config

class RegistrationPage
  constructor: ->
    @emailField = $('gt-email-field')
    @emailInput = @emailField.$ 'input'
    @passwordField = $('gt-password-form').$('[gt-name="passwordField"]')
    @passwordInput = @passwordField.$ 'input'
    @passwordConfirmationField = $('gt-password-form').$('[gt-name="passwordCompareField"]')
    @passwordConfirmationInput = @passwordConfirmationField.$ 'input'
    @registerButton = $('gt-submit-button').$('button')
    @cancelButton = $('gt-back-button').$('button')
    @formErrorField = $('gt-form-error-field').$('div')
    @url = '/#/account/register'

  getPage: ->
    browser.get @url

  getUrl: ->
    "#{config.baseUrl}#{@url}"

  setEmail: (val) ->
    @emailInput.sendKeys val  

  setPassword: (val) ->
    @passwordInput.sendKeys val 

  setPasswordConfirmation: (val) ->
    @passwordConfirmationInput.sendKeys val

  submitForm: ->
    @registerButton.click()

  register: (user, passwordConfirmation) ->
    q.all [
      @setEmail user.email,
      @setPassword user.password,
      @setPasswordConfirmation passwordConfirmation
    ] 
    .then =>
      @submitForm()

  getFormError: ->
    @formErrorField.getText()

  cancel: ->
    @cancelButton.click()

module.exports = RegistrationPage