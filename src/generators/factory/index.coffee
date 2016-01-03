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
      @config.set
        appName: @appname
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
    mainFiles: ->
      @config = @config.getAll()
      factoryName = _.capitalize _.camelCase @answers.name
      
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./frontend/src/#{@answers.name}"),
        moduleName: @answers.name
        factoryName: factoryName
        factoryNameFQ: "#{@config.appName}#{factoryName}"

    "frontend/components.json" : ->
      dest = @destinationPath "./frontend/src/components.json"
      @moduleNamesObj = @fs.readJSON dest
      @moduleNamesObj.factoryModuleNames.push @answers.name
      @fs.writeJSON dest, @moduleNamesObj

    "service-modules.coffee": ->
      dest = @destinationPath("./frontend/src/factory-modules.coffee")
      content = """Module = angular.module "#{@config.appName}-services", ["""

      _.forEach @moduleNamesObj.factoryModuleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

module.exports = GarlicWebappUiGenerator
