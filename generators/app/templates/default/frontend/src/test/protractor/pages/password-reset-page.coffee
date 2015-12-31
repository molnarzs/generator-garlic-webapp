q = require 'q'
config = require('../config').config

class PasswordResetPage
  constructor: ->
    @emailField = $('gt-email-field')
    @emailInput = @emailField.$ 'input'
    @submitButton = $('gt-submit-button').$('button')
    @formErrorField = $('gt-form-error-field').$('div')
    @acknowledgeField = $('gt-acknowledge')
    @url = '/#/account/password/reset'

  getPage: ->
    browser.get @url

  getUrl: ->
    "#{config.baseUrl}#{@url}"

  reset: (val) ->
    @emailInput.sendKeys(val).then => @submitForm() 
 
  submitForm: ->
    @submitButton.click()

  getFormError: ->
    @formErrorField.getText()

  getAcknowledgeText: ->
    @acknowledgeField.$('.modal-body').getText()
    
  confirmPopup: ->
    @acknowledgeField.$('button').click()

module.exports = PasswordResetPage