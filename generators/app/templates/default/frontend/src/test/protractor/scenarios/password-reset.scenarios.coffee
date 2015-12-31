chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
should = chai.should()
config = require('../config').config
assertions = require '../support/assertions'
utils = require '../support/utils'
Fixture = require './fixture'
PasswordResetPage = require '../pages/password-reset-page'

describe "Test password reset page", ->
  passwordResetPage = new PasswordResetPage

  beforeEach ->
    passwordResetPage.getPage()
    expect(passwordResetPage.url).isTheCurrentUrl()

  describe "When loading registration page", ->
    it 'should load the page', ->
      # Execute the beforeEach hook only...

  describe "When attempting to reset an existing user password", -> 
    it "should display a popup with confirmation text", ->
      @timeout 10000
      passwordResetPage.reset(Fixture.existingUser.email)
      expect($('gt-acknowledge')).existsOnPage()
      expect(passwordResetPage.getAcknowledgeText()).eventually.match /have sent an email/

  describe 'Test buttons', ->
    previousUrl = '/#/account/login'
    
    beforeEach ->
      browser.get previousUrl
      expect(previousUrl).isTheCurrentUrl()
      passwordResetPage.getPage()
      expect(passwordResetPage.url).isTheCurrentUrl()

    afterEach ->
      expect(previousUrl).isTheCurrentUrl()
      
    describe "After clicking on OK of the popup", ->
      it "should go back to the previous window", ->
        @timeout 10000
        passwordResetPage.reset(Fixture.existingUser.email)
        expect($('gt-acknowledge')).existsOnPage()
        passwordResetPage.confirmPopup()

  describe "When attempting to reset a non-existing user password", -> 
    it "should stay on the current page and show error message", ->
      @timeout 10000
      expect(passwordResetPage.reset(Fixture.nonExistingUser.email)).eventually.resolved
      expect(passwordResetPage.url).isTheCurrentUrl()
      expect(passwordResetPage.formErrorField).existsOnPage()
      expect(passwordResetPage.getFormError()).eventually.match /specified user does not exis/
      