chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
should = chai.should()
config = require('../config').config
assertions = require '../support/assertions'
utils = require '../support/utils'
Fixture = require './fixture'
RegistrationPage = require '../pages/registration_page.coffee'

describe "Test registration page", ->
  registrationPage = new RegistrationPage

  beforeEach ->
    registrationPage.getPage()

  describe "When loading registration page", ->
    it 'should load the page', ->
      expect browser.getCurrentUrl()
      .eventually.equal registrationPage.getUrl()

  describe "When attempting to register an existing user", ->
    it "should display error message", ->
      @timeout 10000
      registrationPage.register(Fixture.existingUser, Fixture.existingUser.password).should.eventually.resolve

      browser.driver.wait ->
        assertions.haveClass(registrationPage.formErrorField, 'vis-hidden').then (res) ->
          return not res
        , ->
      , 10000

      browser.driver.wait ->
        registrationPage.getFormError().then (res) ->
          /specified email address is already in use/.test res
        , ->
      , 10000

  describe "When attempting to register not existing user", ->      
    it "Should register it and go to index page", ->
      @timeout 10000
      registrationPage.register(Fixture.nonExistingUser, Fixture.nonExistingUser.password).should.eventually.resolve
      expect('/#/').isTheCurrentUrl()
      expect($('.gt-logout-link')).existsOnPage()
