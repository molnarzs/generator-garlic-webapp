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
      @config.set
        appName: @appname
      console.log chalk.magenta 'You\'re using the GarlicTech webapp UI generator.'

  prompting: ->
    done = @async()
    cb = (answers) =>
      done()
      @answers = answers

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-component):'
      required: true
    , cb.bind @

  writing:
    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./frontend/src/#{@answers.name}"),
        moduleName: @answers.name
        moduleNameCC: _.camelCase @answers.name

    "frontend/components.json" : ->
      dest = @destinationPath "./frontend/src/components.json"
      @moduleNamesObj = @fs.readJSON dest
      @moduleNamesObj.uiModuleNames.push @answers.name
      @fs.writeJSON dest, @moduleNamesObj

    "ui-modules.coffee": ->
      dest = @destinationPath("./frontend/src/ui-modules.coffee")
      content = """Module = angular.module "#{@config.appName}-ui", ["""

      _.forEach @moduleNamesObj.uiModuleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    "test-page-components.jade": ->
      dest = @destinationPath("./frontend/src/views/test-page/test-page-components.jade")
      content = ""

      _.forEach @moduleNamesObj.uiModuleNames, (moduleName) =>
        content += "div(#{@config.appName}-#{moduleName})\n"

      @fs.write dest, content

    protractor: ->
      pagesFilter = gulpFilter ['**/page.coffee', '**/scenarios.coffee'], {restore: true}
      @registerTransformStream pagesFilter

      @registerTransformStream gulpRename (path) =>
        path.basename = "#{@answers.name}.#{path.basename}"

      @fs.copyTpl @templatePath('protractor/**/*'), @destinationPath("./frontend/src/test/protractor"),
        pageName: @answers.name
        pageNameCC: _.capitalize _.camelCase @answers.name

      @registerTransformStream pagesFilter.restore

module.exports = GarlicWebappUiGenerator
