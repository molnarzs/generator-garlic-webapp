class <%= c.componentNameCC %>
  constructor: ->
    @url = '/#/'

  getPage: ->
    browser.get @url

  getUrl: ->
    "#{config.baseUrl}#{@url}"

module.exports = <%= c.componentNameCC %>