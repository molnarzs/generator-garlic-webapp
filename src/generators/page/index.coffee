util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
gulpFilter = require 'gulp-filter'
gulpRename = require 'gulp-rename'
gulpReplace = require 'gulp-replace'

GarlicWebappUiGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp pages generator.'

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @composeWith 'garlic-webapp:ui', options: {page: true, answers: answers}
      done()

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Page name, without -page (like foo-bar):'
      required: true
    , cb.bind @

  writing:
    protractor: ->
      pagesFilter = gulpFilter ['**/page.coffee', '**/scenarios.coffee'], {restore: true}
      @registerTransformStream pagesFilter

      @registerTransformStream gulpRename (path) =>
        path.basename = "#{@answers.name}.#{path.basename}"

      @fs.copyTpl @templatePath('protractor/**/*'), @destinationPath("./client/test/protractor"),
        pageName: @answers.name
        pageNameCC: "#{_.capitalize _.camelCase @answers.name}Page"

      @registerTransformStream pagesFilter.restore

    "views/index.coffee": ->
      path = @destinationPath "./client/views/index.coffee"
      content = fs.readFileSync path, 'utf8'
      conf = @config.getAll()

      replacedTextState = """
  .state '#{@answers.name}',
      url: '/#{@answers.name}'
      views:
        'main':
          template: '<div #{conf.appName}-#{@answers.name}-page></div>'

    #===== yeoman hook state =====#"""

      content = content.replace '#===== yeoman hook state =====#', replacedTextState

      replacedTextRequire = """
  require './#{@answers.name}-page'
    #===== yeoman hook require =====#"""

      content = content.replace '#===== yeoman hook require =====#', replacedTextRequire
      fs.writeFileSync path, content, 'utf8'

module.exports = GarlicWebappUiGenerator
