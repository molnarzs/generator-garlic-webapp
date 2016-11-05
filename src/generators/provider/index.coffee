util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappProviderGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp provider generator.'

  prompting: ->
    done = @async()
    cb = (answers) =>
      done()
      @answers = answers
      @moduleNames.push @answers.name
      @conf.providerName = _.upperFirst _.camelCase @answers.name
      @conf.moduleName = "#{@conf.appNameCC}.#{@conf.providerName}"
      @conf.providerNameFQ = "#{@conf.appNameCC}.#{@conf.providerName}"

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Provider name (like my-service - mind that providers are actually for services): '
      required: true
    , cb.bind @

  writing:
    createConfig: ->
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @moduleNames = @conf.angularModules.providers
      @moduleNames.push @answers.name
      @conf.providerName = _.upperFirst _.camelCase @answers.name
      @conf.moduleName = "#{@conf.angularModuleName}.#{@conf.providerName}"
      @conf.providerNameFQ = @conf.moduleName

    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src/#{@answers.name}"), {c: @conf}

    "service-modules.coffee": ->
      dest = @destinationPath("./src/provider-modules.coffee")
      content = """Module = angular.module "#{@conf.appNameCC}.providers", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappProviderGenerator
