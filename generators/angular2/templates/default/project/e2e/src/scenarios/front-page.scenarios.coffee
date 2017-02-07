FrontPage = require '../pages/front_page.coffee'

describe.skip 'Test FrontPage', ->
  page = new FrontPage()

  beforeEach ->
    page.getPage()

  describe "When loading page", ->
    it 'should load page', ->
      expect browser.getCurrentUrl()
      .eventually.equal page.getUrl()
