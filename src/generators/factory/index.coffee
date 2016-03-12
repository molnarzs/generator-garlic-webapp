util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'

GarlicWebappUiGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp factory generator.'
      @moduleNames = @conf.angularModules.factories
      @conf.appNameCC = _.capitalize _.camelCase @conf.appName

  prompting: ->
    done = @async()
    cb = (answers) =>
      done()
      @answers = answers
      @moduleNames.push @answers.name
      @conf.factoryName = _.capitalize _.camelCase @answers.name
      @conf.moduleName = "#{@conf.appNameCC}.#{@conf.factoryName}"
      @conf.factoryNameFQ = "#{@conf.appNameCC}.#{@conf.factoryName}"

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-factory): '
      required: true
    , cb.bind @

  writing:
    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./client/#{@answers.name}"), {c: @conf}

    "factory-modules.coffee": ->
      dest = @destinationPath("./client/factory-modules.coffee")
      content = """Module = angular.module "#{@conf.appNameCC}.factories", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappUiGenerator
