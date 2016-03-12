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
      console.log chalk.magenta 'You\'re using the GarlicTech webapp service generator.'
      @moduleNames = @conf.angularModules.services
      @conf.appNameCC = _.capitalize _.camelCase @conf.appName

  prompting: ->
    done = @async()
    cb = (answers) =>
      done()
      @answers = answers
      @moduleNames.push @answers.name
      @conf.serviceName = _.capitalize _.camelCase @answers.name
      @conf.moduleName = "#{@conf.appNameCC}.#{@conf.serviceName}"
      @conf.serviceNameFQ = "#{@conf.appNameCC}.#{@conf.serviceName}"

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-service): '
      required: true
    , cb.bind @

  writing:
    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./client/#{@answers.name}"), {c: @conf}

    "service-modules.coffee": ->
      dest = @destinationPath("./client/service-modules.coffee")
      content = """Module = angular.module "#{@conf.appNameCC}.services", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappUiGenerator
