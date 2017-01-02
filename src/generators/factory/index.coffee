util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappFactoryGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp factory generator.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      done()
      @answers = answers

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-factory): '
      required: true
    , cb.bind @


  writing:
    createConfig: ->
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @moduleNames = @conf.angularModules.factories
      @moduleNames.push @answers.name
      @conf.factoryName = _.upperFirst _.camelCase @answers.name
      @conf.moduleName = "#{@conf.angularModuleName}.#{@conf.factoryName}"
      @conf.factoryNameFQ = @conf.moduleName

    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src/#{@answers.name}"), {c: @conf}

    "factory-modules.coffee": ->
      dest = @destinationPath("./src/factory-modules.coffee")
      content = """Module = angular.module "#{@conf.appNameCC}.factories", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappFactoryGenerator
