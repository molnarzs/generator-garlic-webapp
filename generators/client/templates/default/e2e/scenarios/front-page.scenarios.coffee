FrontPage = require '../pages/front_page.coffee'

describe 'Test FrontPage', ->
  page = new FrontPage()

  beforeEach ->
    page.getPage()

  describe "When loading page", ->
    it 'should load page', ->
      expect browser.getCurrentUrl()
      .eventually.equal page.getUrl()

    it "should contain the default translation text", ->
      page.getTranslationContent().should.eventually.equal "Translation of 'English': English"


  describe "When changing translation to Hungarian", ->
    it "should update translation text properly", (done) ->
      page.changeToHungarian()
      .then ->
        page.getTranslationContent().should.eventually.equal "Translation of 'English': Angol"
        done()

