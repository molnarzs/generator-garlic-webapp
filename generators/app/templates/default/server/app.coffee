cowsay = require "cowsay"
chalk = require 'chalk'
console.log chalk.blue cowsay.say {text: "<%= appNameAsIs %> server", e: "oO", T: 'U '}

app = (require 'express')()

app.use (require 'helmet' )()
app.use (require 'cors')()
app.use (require 'morgan')('dev')

bodyParser = require 'body-parser'
app.use bodyParser.urlencoded { extended: true }
app.use bodyParser.json()

app.use (require 'cookie-parser')()
(require './app-config-local') app

module.exports = app
