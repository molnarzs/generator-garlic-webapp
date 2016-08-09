yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappAngularJqueryGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re adding jquery to the angular app.'

  writing:
    "vendor/index.json": ->
      cb = @async()
      path = @destinationPath "./src/vendor/index.coffee"
      content = fs.readFileSync path, 'utf8'

      content = """
  require "expose?$!expose?jQuery!jquery"\n
      """ + content

      fs.writeFileSync path, content, 'utf8'
      cb()


  install:
    dependencies: ->
      @npmInstall ['jquery'], { 'save': true }

module.exports = GarlicWebappAngularJqueryGenerator
