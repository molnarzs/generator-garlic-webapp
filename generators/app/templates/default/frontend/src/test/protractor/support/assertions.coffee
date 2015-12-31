chai = require 'chai'
config = require('../config').config
q = require 'q'

module.exports = 
  haveClass: (obj, className) ->
    obj.getAttribute 'class'
    .then (classes) ->
      classes.split(' ').indexOf(className) isnt -1
 
chai.use (chai, utils) ->
  Assertion = chai.Assertion

  Assertion.addMethod 'haveClass', (className) ->
    @_obj.getAttribute 'class'
    .then (classes) =>
      @assert classes.split(' ').indexOf(className) isnt -1 
        , "Element should have CSS class #{className}. Actual classes: #{classes}"
        , "Element should not have CSS class #{className}. Actual classes: #{classes}"
        , className
        , classes
  
  Assertion.addMethod 'isTheCurrentUrl', (timeout = 10000) ->
    res = false
    currentUrl = @_obj

    browser.wait =>
      browser.getCurrentUrl().then (url) =>
        currentUrl = url
        url is "#{config.baseUrl}#{@_obj}"
    , timeout
    .then ->
      res = true
    .thenFinally =>
      @assert res
        , "Browser is at page #{currentUrl} instead of #{@_obj}"
        , "Browser should not be at #{@_obj}"
        , @_obj
        , currentUrl

  Assertion.addMethod 'existsOnPage', (timeout = 10000) ->
    res = false
    browser.wait EC.visibilityOf(@_obj), timeout
    .then ->
        res = true
    .thenFinally =>
      @assert res
        , "Element #{element} should show up in page"
        , "Element #{element} should not show up in page"
        , element
        , element