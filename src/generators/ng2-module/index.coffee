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
      console.log chalk.magenta 'You\'re using the GarlicTech webapp Angular 2 module generator.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
      type    : 'input'
      name    : 'name'
      message : 'Module name with optional path relative to src/app, and without "module" (like base/foo): '
      required: true
    }, {
      type    : 'confirm'
      name    : 'isRouting'
      message : 'Generate routing?'
      required: true
      default : false
      store   : true
    }], cb.bind @


  writing:
    createConfig: ->
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @conf.moduleName = _.upperFirst _.camelCase path.basename @answers.name + "Module"
      @conf.routingModuleName = "#{@conf.moduleName}Routing"


    mainFiles: ->
      console.log @answers.isRouting
      if @answers.isRouting
        @fs.copyTpl @templatePath('with-routing/**/*'), @destinationPath("./src/app/#{@answers.name}"), {c: @conf}
      else
        @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src/app/#{@answers.name}"), {c: @conf}

module.exports = GarlicWebappNg2ServiceGenerator
