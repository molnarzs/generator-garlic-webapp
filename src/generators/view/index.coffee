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

GarlicWebappPageGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp view generator.'

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @composeWith 'garlic-webapp:directive', options: {view: true, answers: answers}
      done()

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'view name, without -view (like foo-bar):'
      required: true
    , cb.bind @

  writing:
    createConfig: ->
      generatorLib.createDirectiveConfig.bind(@)()


    protractor: ->
      pagesFilter = gulpFilter ['**/view.coffee', '**/scenarios.coffee'], {restore: true}
      @registerTransformStream pagesFilter

      @registerTransformStream gulpRename (path) =>
        path.basename = "#{@answers.name}.#{path.basename}"

      @fs.copyTpl @templatePath('e2e/**/*'), @destinationPath("./e2e"), {c: @conf}

      @registerTransformStream pagesFilter.restore

    "views/index.coffee": ->
      path = @destinationPath "./src/views/index.coffee"
      content = fs.readFileSync path, 'utf8'
      headerDirectiveName = "#{_.kebabCase @conf.angularModuleName}-main-header"

      replacedTextState = """
  .state '#{@answers.name}',
      url: '/#{@answers.name}'
      views:
        'header':
          template: '<#{headerDirectiveName}></#{headerDirectiveName}>'
        'main':
          template: '<#{@conf.directiveNameKC}></#{@conf.directiveNameKC}>'

    #===== yeoman hook state =====#"""

      content = content.replace '#===== yeoman hook state =====#', replacedTextState

      replacedTextRequire = """
  require './#{@answers.name}-view'
    #===== yeoman hook require =====#"""

      content = content.replace '#===== yeoman hook require =====#', replacedTextRequire
      fs.writeFileSync path, content, 'utf8'

module.exports = GarlicWebappPageGenerator
