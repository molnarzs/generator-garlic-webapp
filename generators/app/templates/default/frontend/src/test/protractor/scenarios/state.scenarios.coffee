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

describe 'Test state transitions', ->
  describe "When going from login state to register state", ->
    it "address bar should change accordingly", ->
      loginPage = new LoginPage
      registrationPage = new RegistrationPage
      loginPage.getPage()
      expect(browser.getCurrentUrl()).eventually.equal loginPage.getUrl()
      loginPage.clickOnSignup()
      expect(browser.getCurrentUrl()).eventually.equal registrationPage.getUrl()