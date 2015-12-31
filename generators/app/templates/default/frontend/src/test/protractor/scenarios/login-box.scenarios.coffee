chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
should = chai.should()
config = require('../config').config
assertions = require '../support/assertions'
Utils = require '../support/utils'
LoginPage = require '../pages/login_page'
RegistrationPage = require '../pages/registration_page'
PasswordResetPage = require '../pages/password-reset-page'
Fixture = require './fixture'

describe 'Test login page', ->
  loginPage = new LoginPage

  beforeEach ->
    loginPage.getPage()

  describe "When loading login page", ->
    it 'should load login page', ->
      expect browser.getCurrentUrl()
      .eventually.equal loginPage.getUrl()

    it 'field setters/getters should work', ->
      loginPage.setEmail "value"
      loginPage.getEmail().should.eventually.equal "value"
      loginPage.setPassword "value"
      loginPage.getPassword().should.eventually.equal "value"

  describe 'Right after loading page', ->
    it 'should contain empty fields, no error messages', ->
      loginPage.getEmail().should.eventually.equal ''
      loginPage.getEmailError().should.eventually.equal ''
      loginPage.emailError.should.haveClass 'vis-hidden'
      loginPage.passwordError.should.haveClass 'vis-hidden'
      loginPage.formError.should.haveClass 'vis-hidden'
      loginPage.passwordField.$('.form-group').should.not.haveClass 'has-error'
      loginPage.emailField.$('.form-group').should.not.haveClass 'has-error'

  describe "When user does not write into the form", ->
    it 'clicking into the fields should change nothing', ->
      @timeout 5000
      loginPage.clickOnEmail().should.eventually.resolved
      loginPage.getEmail().should.eventually.equal ''
      loginPage.getEmailError().should.eventually.equal ''
      loginPage.getFormError().should.eventually.equal ''
      loginPage.clickOnPassword().should.eventually.resolved
      loginPage.getEmail().should.eventually.equal ''
      loginPage.getEmailError().should.eventually.equal ''
      loginPage.getPassword().should.eventually.equal ''
      loginPage.getPasswordError().should.eventually.equal '' 
      loginPage.getFormError().should.eventually.equal ''
      loginPage.clickOnEmail().should.eventually.resolved
      loginPage.getPassword().should.eventually.equal ''
      loginPage.getPasswordError().should.eventually.equal ''
      loginPage.getFormError().should.eventually.equal ''

    it 'submitting the form should reveal form errors on each fields', ->
      loginPage.submitForm().should.eventually.resolved
      loginPage.passwordField.$('.form-group').should.haveClass 'has-error'
      loginPage.emailField.$('.form-group').should.haveClass 'has-error'

  describe "When user writes bad email", ->
    it 'email field should display error in case of invalid input, but only after blur', ->
      loginPage.setEmail("bad").should.eventually.resolved
      loginPage.getEmailError().should.eventually.equal '' 
      loginPage.clickOnPassword().should.eventually.resolved
      loginPage.getEmailError().should.eventually.not.equal ''    
    it 'wrong email should add has-error class to the field', ->
      loginPage.setEmail("bad").should.eventually.resolved
      loginPage.emailField.$('.form-group').should.not.haveClass 'has-error'
      loginPage.clickOnPassword().should.eventually.resolved
      loginPage.emailField.$('.form-group').should.haveClass 'has-error'

  describe "When user writes bad password", ->
    it 'password field should display error in case of invalid input, but only after blur', ->
      loginPage.setPassword("bad").should.eventually.resolved
      loginPage.getPasswordError().should.eventually.equal ''
      loginPage.clickOnEmail().should.eventually.resolved
      loginPage.getPasswordError().should.eventually.not.equal ''

    it 'wrong password should add has-error class to the field', ->
      loginPage.setPassword("bad").should.eventually.resolved
      loginPage.passwordField.$('.form-group').should.not.haveClass 'has-error'
      loginPage.clickOnEmail().should.eventually.resolved
      loginPage.passwordField.$('.form-group').should.haveClass 'has-error'

  describe "When user writes good email", ->
    it 'email field should not display error', ->
      loginPage.setEmail("a@a.hu").should.eventually.resolved
      loginPage.clickOnPassword().should.eventually.resolved
      loginPage.getEmailError().should.eventually.equal '' 

    it 'email field should have has-success class, but only after blur', ->
      loginPage.setEmail("a@a.hu").should.eventually.resolved
      loginPage.emailField.$('.form-group').should.not.haveClass 'has-success'
      loginPage.emailField.$('.form-group').should.not.haveClass 'has-error'
      loginPage.clickOnPassword().should.eventually.resolved
      loginPage.emailField.$('.form-group').should.haveClass 'has-success'
      loginPage.emailField.$('.form-group').should.not.haveClass 'has-error'

  describe "When user writes good password", ->
    it 'password field should not display error', ->
      loginPage.setPassword("12345678").should.eventually.resolved
      loginPage.clickOnEmail().should.eventually.resolved
      loginPage.getPasswordError().should.eventually.equal '' 

    it 'email field should have has-success class, but only after blur', ->
      loginPage.setPassword("12345678").should.eventually.resolved
      loginPage.passwordField.$('.form-group').should.not.haveClass 'has-success'
      loginPage.passwordField.$('.form-group').should.not.haveClass 'has-error'
      loginPage.clickOnEmail().should.eventually.resolved
      loginPage.passwordField.$('.form-group').should.haveClass 'has-success'
      loginPage.passwordField.$('.form-group').should.not.haveClass 'has-error'

  describe "In case of wrong credentials", ->
    it 'should not log in, form error must be displayed instead', ->
      @timeout 10000
      expect(loginPage.login Fixture.nonExistingUser).eventually.resolve

      browser.driver.wait ->
        assertions.haveClass(loginPage.formError, 'vis-hidden').then (res) ->
          return not res
        , ->
      , 10000

      browser.driver.wait ->
        loginPage.getFormError().then (res) ->
           /specified user does not exist/.test res
        , ->
      , 10000

  describe "When user writes good email and password", ->
    it 'should not display form error', ->
      loginPage.setPassword("12345678").should.eventually.resolved
      loginPage.setEmail("bad@a.hu").should.eventually.resolved
      loginPage.clickOnPassword().should.eventually.resolved
      loginPage.formError.should.haveClass 'vis-hidden'

    it 'should successfully log in with password, and should be redirected to index', ->
      @timeout 10000
      browser.get config.baseUrl
      loginPage.getPage()
      expect(loginPage.login Fixture.existingUser).eventually.resolve

      browser.driver.wait ->
        browser.driver.getCurrentUrl().then (url) ->
          return url is "#{config.baseUrl}/#/"
      , 10000

      loginPage.logout()

  describe "When user clicks on signup link", ->
    it 'should go to register page', ->
      registrationPage = new RegistrationPage
      loginPage.clickOnSignup()
      expect(browser.getCurrentUrl()).eventually.equal registrationPage.getUrl()

  describe "When user clicks on password reset link", ->
    it 'should go to password reset page', ->
      passwordResetPage = new PasswordResetPage
      loginPage.clickOnPasswordReset()
      expect(browser.getCurrentUrl()).eventually.equal passwordResetPage.getUrl()

  describe.skip "When coming back from another page to an untouched login page", ->
    it "all the error fields must be invisible", ->
      registrationPage = new RegistrationPage
      loginPage.clickOnSignup()
      browser.navigate().back()
      loginPage.emailError.should.haveClass 'vis-hidden'
      loginPage.passwordError.should.haveClass 'vis-hidden'
      loginPage.formError.should.haveClass 'vis-hidden'
