<%= c.componentNameCC %> = require '../views/<%= c.componentNameKC %>.view.coffee'

describe.skip 'Test <%= c.componentNameCC %>', ->
  page = new <%= c.componentNameCC %>()

  beforeEach ->
    page.getPage()

  describe "When loading <%= c.componentNameCC %>", ->
    it 'should load it', ->
      expect browser.getCurrentUrl()
      .eventually.equal page.getUrl()
