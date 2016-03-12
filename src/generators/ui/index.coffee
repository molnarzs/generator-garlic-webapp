util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
gulpFilter = require 'gulp-filter'
gulpRename = require 'gulp-rename'

GarlicWebappUiGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      if not @options.page
        console.log chalk.magenta 'You\'re using the GarlicTech webapp UI generator.'
      
      @conf = @config.getAll()
      @moduleNames = if @options.page then @conf.angularModules.pages else @conf.angularModules.ui
      @conf.appNameKC = _.kebabCase @conf.appName
      @conf.appNameCC = _.capitalize _.camelCase @conf.appName

  prompting: ->
    if @options.page then return

    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-component):'
      required: true
    , cb.bind @

  writing:
    createConfig: ->
      if @options.page then @answers = @options.answers

      @moduleNames.push @answers.name
      @conf.moduleNameCC = _.capitalize _.camelCase @answers.name
      @conf.moduleNameKC = _.kebabCase @answers.name
      @conf.directiveNameCC = "#{_.camelCase @conf.appName}#{@conf.moduleNameCC}"
      @conf.directiveNameKC = "#{@conf.appNameKC}-#{@conf.moduleNameKC}"

      if @options.page
        @conf.directiveNameCC = "#{@conf.directiveNameCC}Page"
        @conf.directiveNameKC = "#{@conf.directiveNameKC}-page"

    mainFiles: ->
      root = "#{@answers.name}"
      @conf.moduleNameFQ = "#{@conf.appNameCC}.#{@conf.moduleNameCC}"
  
      if @options.page
        root = "views/#{@answers.name}-page"
        @conf.moduleNameFQ = "#{@conf.moduleNameFQ}.page"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./client/#{root}"), {c: @conf}

    "ui-modules.coffee": ->
      if @options.page then return

      dest = @destinationPath("./client/ui-modules.coffee")
      content = """Module = angular.module "#{@conf.appNameCC}.ui", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    "test-page-components.jade": ->
      if @options.page then return

      dest = @destinationPath("./client/views/test-page/test-page-components.jade")
      content = ""

      _.forEach @moduleNames, (moduleName) =>
        content += "div(#{@conf.appNameKC}-#{moduleName})\n"

      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappUiGenerator
