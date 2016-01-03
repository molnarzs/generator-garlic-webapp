class <%= pageNameCC %>
  constructor: ->
    @url = '/#/'

  getPage: ->
    browser.get @url

  getUrl: ->
    "#{config.baseUrl}#{@url}"

module.exports = <%= pageNameCC %>