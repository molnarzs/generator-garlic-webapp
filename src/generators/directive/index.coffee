util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs-extra'
path = require 'path'
gulpFilter = require 'gulp-filter'
gulpRename = require 'gulp-rename'
generatorLib = require '../lib'

GarlicWebappDirectiveGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      if not @options.view
        console.log chalk.magenta 'You\'re using the GarlicTech webapp directive generator.'

      @folder = "./src"


  prompting: ->
    if @options.view then return

    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
      type    : 'input'
      name    : 'name'
      message : 'Module name (like foo-component):'
      required: true
    }, {
      type    : 'confirm'
      name    : 'isExtractAllowed'
      message : 'Allow extracting the templates?'
      required: true
      store   : true
      default : true
    }], cb.bind @

  writing:
    createConfig: ->
      generatorLib.createDirectiveConfig.bind(@)()
      console.log "templateUrl: '#{@conf.moduleName}'"

      if @answers.isExtractAllowed
        @conf.directiveHeader = ""
        @conf.directiveTemplate = "templateUrl: '#{@conf.moduleName}'"
        @conf.cssGlobals = ""
      else
        @conf.directiveHeader = "require './style'\n"
        @conf.directiveTemplate = "template: require './ui'"
        @conf.cssGlobals = "@import \"~style/globals\";\n"


    mainFiles: ->
      root = "#{@answers.name}"

      if @options.view
        root = "views/#{@answers.name}-view"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("#{@folder}/#{root}"), {c: @conf}

    "directive-modules.coffee": ->
      if @options.view then return

      dest = @destinationPath("#{@folder}/directive-modules.coffee")
      content = """Module = angular.module "#{@conf.angularModuleName}.Directives", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content

    "test-view-components.jade": ->
      if @options.view then return

      dest = @destinationPath("#{@folder}/views/test-view/test-view-components.jade")
      content = ""

      _.forEach @moduleNames, (moduleName) =>
        content += "#{@conf.appNameFQ}-#{@answers.name}\n"

      @fs.write dest, content

    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules


    templates: ->
      if not @answers.isExtractAllowed then return
      done = @async()
      dstPath = @destinationPath "./src/templates"

      if not fs.existsSync dstPath
        newRoot = path.join __dirname, '..', 'app', 'templates'
        @sourceRoot newRoot
        fs.mkdirsSync dstPath
        @fs.copyTpl @templatePath('default/src/templates/**/*'), dstPath, {conf: @conf}

      done()


  end:
    templates: ->
      if not @answers.isExtractAllowed then return
      done = @async()
      dstIndex = @destinationPath "./src/templates/index.coffee"
      content = fs.readFileSync dstIndex, 'utf8'

      replacedText = """
        #===== yeoman hook =====
          require '../#{@answers.name}/style'
          $templateCache.put '#{@conf.moduleName}', require '../#{@answers.name}/ui'
      """

      content = content.replace '#===== yeoman hook =====', replacedText
      fs.writeFileSync dstIndex, content, 'utf8'
      done()


module.exports = GarlicWebappDirectiveGenerator
