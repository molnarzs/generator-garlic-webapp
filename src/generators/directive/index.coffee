util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
gulpFilter = require 'gulp-filter'
gulpRename = require 'gulp-rename'
generatorLib = require '../lib'

GarlicWebappDirectiveGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      if not @options.view
        console.log chalk.magenta 'You\'re using the GarlicTech webapp directive generator.'
  
      @folder = "./src"


  prompting: ->
    if @options.view then return

    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-component):'
      required: true
    }]
    , cb.bind @

  writing:
    createConfig: ->
      generatorLib.createDirectiveConfig.bind(@)()


    mainFiles: ->
      root = "#{@answers.name}"
  
      if @options.view
        root = "views/#{@answers.name}-view"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("#{@folder}/#{root}"), {c: @conf}

    "directive-modules.coffee": ->
      if @options.view then return

      dest = @destinationPath("#{@folder}/directive-modules.coffee")
      content = """Module = angular.module "#{@conf.angularModuleName}.Directives", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    "test-view-components.jade": ->
      if @options.view then return

      dest = @destinationPath("#{@folder}/views/test-view/test-view-components.jade")
      content = ""

      _.forEach @moduleNames, (moduleName) =>
        content += "div(#{@conf.appNameFQ}-#{@answers.name})\n"

      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappDirectiveGenerator
