module.exports.injectServices = (services...) ->
  obj = {}
  beforeEach ->
    inject ($injector) ->
      obj[s] =  $injector.get(s) for s in services
      return
    return
  return obj