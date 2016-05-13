process.on 'uncaughtException', (err) ->
  console.trace err

require './globals'
module.exports = require './app'
