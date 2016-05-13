chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
should = chai.should()
FrontPage = require '../pages/front_page.coffee'

describe.skip 'Test FrontPage', ->
  page = new FrontPage()

  beforeEach ->
    page.getPage()

  describe "When loading page", ->
    it 'should load page', ->
      expect browser.getCurrentUrl()
      .eventually.equal page.getUrl()
