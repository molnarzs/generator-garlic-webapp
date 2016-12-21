util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
generatorLib = require '../lib'

GarlicWebappNg2ServiceGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp Angular 2 service generator.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Service name with optional path relative to src (like base/foo-service): '
      required: true
    , cb.bind @


  writing:
    createConfig: ->
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @conf.serviceName = _.upperFirst _.camelCase path.basename @answers.name


    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src/app/#{@answers.name}"), {c: @conf}


module.exports = GarlicWebappNg2ServiceGenerator
