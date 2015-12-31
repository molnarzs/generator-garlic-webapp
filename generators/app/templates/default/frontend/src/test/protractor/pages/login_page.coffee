q = require 'q'
config = require('../config').config

class LoginPage
  constructor: ->
    @emailField = $('gt-email-field')
    @emailInput = @emailField.$ 'input'
    @emailError = @emailField .$('gt-error-field').$('div')
    @passwordField = $('gt-password-field')
    @passwordInput = @passwordField.$ 'input'
    @passwordError = @passwordField.$('gt-error-field').$('div')
    @formError = $('gt-form-error-field').$('div')
    @loginButton = $('gt-submit-button').$('button')
    @logoutLink = -> $('.gt-logout-link').$('a')
    @signupLink = $('h3').$('a')
    @passwordResetLink = $('.forgotPwd').$('a')
    @url = '/#/account/login'

  getPage: ->
    browser.get @url

  getUrl: ->
    "#{config.baseUrl}#{@url}"

  setEmail: (val) ->
    @emailInput.sendKeys val

  getEmail: ->
    @emailInput.getAttribute 'value'

  getEmailError: ->
    @emailError.getText()

  setPassword: (val) ->
    @passwordInput.sendKeys val

  getPassword: ->
    @passwordInput.getAttribute 'value'

  getPasswordError: ->
    @passwordError.getText()

  getFormError: ->
    @formError.getText()

  blur: ->
    $('h3').click()

  clickOnEmail: ->
    @emailInput.click()

  clickOnPassword: ->
    @passwordInput.click()

  clickOnSignup: ->
    @signupLink.click()

  clickOnPasswordReset: ->
    @passwordResetLink.click()

  submitForm: ->
    @loginButton.click()

  login: (user) ->
    @setPassword user.password
    .then =>
      @setEmail user.email
    .then =>
      @submitForm()

  logout: ->
    @logoutLink()?.click()

module.exports = LoginPage