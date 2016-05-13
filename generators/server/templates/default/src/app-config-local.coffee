module.exports = (app) ->
  # Configure app further here
  app.use '/', require './routes/api'
