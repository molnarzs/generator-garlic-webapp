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
      @conf = @config.getAll()

      if not @options.page
        console.log chalk.magenta 'You\'re using the GarlicTech webapp directive generator.'
  
      @conf.folder = "./src"


  prompting: ->
    if @options.page then return

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
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @moduleNames = if @options.page then @conf.angularModules.pages else @conf.angularModules.directives
      directiveNameCC = _.capitalize _.camelCase @answers.name
      @conf.moduleName = "#{@conf.angularModuleName}.#{directiveNameCC}"
      @moduleNames.push @answers.name

      if @options.page
        @conf.moduleName = "#{@conf.angularModuleName}.#{moduleName}.View"
        @conf.directiveNameCC = "#{@conf.directiveNameCC}View"
        @conf.directiveNameKC = "#{@conf.directiveNameKC}-view"
      else
        @conf.directiveNameCC = "#{@conf.appNameFQcC}#{directiveNameCC}"
        @conf.directiveNameKC = "#{@conf.appNameFQ}-#{@answers.name}"


    mainFiles: ->
      root = "#{@answers.name}"
  
      if @options.page
        root = "views/#{@answers.name}-view"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("#{@conf.folder}/#{root}"), {c: @conf}

    "directive-modules.coffee": ->
      if @options.page then return

      dest = @destinationPath("#{@conf.folder}/directive-modules.coffee")
      content = """Module = angular.module "#{@conf.angularModuleName}.Directives", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    "test-page-components.jade": ->
      if @options.page then return

      dest = @destinationPath("#{@conf.folder}/views/test-page/test-page-components.jade")
      content = ""

      _.forEach @moduleNames, (moduleName) =>
        content += "div(#{@conf.appNameFQ}-#{@answers.name})\n"

      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappDirectiveGenerator
