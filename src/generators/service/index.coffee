util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappServiceGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp service generator.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-service): '
      required: true
    , cb.bind @


  writing:
    createConfig: ->
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @moduleNames = @conf.angularModules.services
      @moduleNames.push @answers.name
      @conf.serviceName = _.upperFirst _.camelCase @answers.name
      @conf.moduleName = "#{@conf.angularModuleName}.#{@conf.serviceName}"
      @conf.serviceNameFQ = @conf.moduleName


    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src/#{@answers.name}"), {c: @conf}

    "service-modules.coffee": ->
      dest = @destinationPath("./src/service-modules.coffee")
      content = """Module = angular.module "#{@conf.angularModuleName}.Services", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappServiceGenerator
