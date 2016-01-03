<%= pageNameCC %> = require '../pages/<%= pageName %>.page.coffee'

describe.skip 'Test <%= pageNameCC %>', ->
  page = new <%= pageNameCC %>()

  beforeEach ->
    page.getPage()

  describe "When loading page", ->
    it 'should load page', ->
      expect browser.getCurrentUrl()
      .eventually.equal page.getUrl()
