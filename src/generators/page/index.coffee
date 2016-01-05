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
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp UI generator.'
      @moduleNames = @conf.angularModules.ui
      @conf.appNameKC = _.kebabCase @conf.appName
      @conf.appNameCC = _.capitalize _.camelCase @conf.appName

  prompting: ->
    done = @async()
    cb = (answers) =>
      done()
      @answers = answers
      @moduleNames.push @answers.name
      @conf.moduleNameCC = _.capitalize _.camelCase @answers.name
      @conf.moduleNameKC = _.kebabCase @answers.name
      @conf.directiveNameCC = "#{@conf.appNameCC}#{@conf.moduleNameCC}"
      @conf.directiveNameKC = "#{@conf.appNameKC}-#{@conf.moduleNameKC}"

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-component):'
      required: true
    , cb.bind @

  writing:
    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./frontend/src/#{@answers.name}"),
        moduleNameFQ: "#{@conf.appNameCC}.#{@conf.moduleNameCC}"
        directiveNameCC: @conf.directiveNameCC
        directiveNameKC: @conf.directiveNameKC

    "ui-modules.coffee": ->
      dest = @destinationPath("./frontend/src/ui-modules.coffee")
      content = """Module = angular.module "#{@conf.appNameCC}.ui", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    "test-page-components.jade": ->
      dest = @destinationPath("./frontend/src/views/test-page/test-page-components.jade")
      content = ""

      _.forEach @moduleNames, (moduleName) =>
        content += "div(#{@conf.appNameKC}-#{moduleName})\n"

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

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules

module.exports = GarlicWebappUiGenerator
