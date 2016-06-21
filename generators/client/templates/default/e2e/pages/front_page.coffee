class FrontPage
  constructor: ->
    @translationElement = $('#translation')
    @hungarianLink = element By.cssContainingText('.language-selector-container a', 'Magyar')
    @url = '/#/'

  getPage: ->
    browser.get @url

  getUrl: ->
    "#{config.baseUrl}#{@url}"

  getTranslationContent: ->
    @translationElement.getText()

  changeToHungarian: ->
    @hungarianLink.click()


module.exports = FrontPage