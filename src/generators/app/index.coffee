util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
mkdirp = require 'mkdirp'
jsonfile = require 'jsonfile'
execute = require('child_process').execSync
generatorLib = require '../lib'

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing: ->
    @config.set
      appname: @appname
      angularModules:
        directives: []
        services: []
        factories: []
        views: []
        providers: []

    console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @config.set {scope: @answers.scope}
      @config.set {projectType: @answers.projectType}
      done()

    @prompt [{
        type    : 'input',
        name    : 'scope',
        default : 'garlictech',
        message : 'Project scope (company github team):'
        store   : true
      }, {
        type    : 'list'
        name    : 'projectType'
        default : 'module'
        choices : ['module', 'site']
        message : 'Project type:'
        store   : true
      }, {
        type    : 'confirm'
        name    : 'isRepo'
        default : true
        message : 'Create github repo?'
        store   : true
      }
    ], cb.bind @

  writing:
    createConfig: ->
      generatorLib.createConfig.bind(@)()
      angularModuleName = "#{@conf.scopeCC}.#{_.capitalize _.camelCase @appname}"
      @conf.angularModuleName = angularModuleName

      @config.set
        angularModuleName: angularModuleName
        scope: @answers.scope

  
    mainFiles: ->
      cb = @async()

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"),
        conf: @conf

      @fs.copyTpl @templatePath('dotfiles/_travis.yml'), @destinationPath("./.travis.yml"),
        conf: @conf
      
      @fs.copyTpl @templatePath('dotfiles/_npmignore'), @destinationPath("./.npmignore"),
        conf: @conf

      @fs.copy @templatePath('default_assets/**/*'), @destinationPath("./src/")
      cb()


    "src/directive-modules.coffee" : ->
      dest = @destinationPath "./src/directive-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Directives", []
module.exports = Module.name
"""


    "src/service-modules.coffee" : ->
      dest = @destinationPath "./src/service-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Services", []
module.exports = Module.name
"""


    "src/factory-modules.coffee" : ->
      dest = @destinationPath "./src/factory-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Factories", []
module.exports = Module.name
"""

    "src/provider-modules.coffee" : ->
      dest = @destinationPath "./src/provider-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Providers", []
module.exports = Module.name
"""

    projectTypeFiles: ->
      if @conf.projectType is 'module'
        @fs.copyTpl @templatePath('module/**/*'), @destinationPath("./"), {conf: @conf}
      else
        @fs.copyTpl @templatePath('site/**/*'), @destinationPath("./"), {conf: @conf}


    "src/views/test-page/test-view-components.jade" : ->
      if @conf.projectType is 'site'
        dest = @destinationPath "./src/views/test-view/test-view-components.jade"
        if not @fs.exists dest then @fs.write dest, ""


    "src/index.coffee": ->
      if @conf.projectType is 'site'
        dest = @destinationPath "./src/index.coffee"
        content = @fs.read dest

        replacedText = """
          #===== yeoman hook modules =====
            require './views'
            require './footer'
            require './main-header'"""

        content = content.replace '#===== yeoman hook modules =====', replacedText
        @fs.write dest, content

    dotfiles: ->
      @fs.copy @templatePath('default/.*'), @destinationPath("./")


    repo: ->
      if @answers.isRepo
        @composeWith 'garlic-webapp:github'

  end:
    docker: ->
      @composeWith 'garlic-webapp:angular-docker'

    
    "package.json": ->
      if @conf.projectType is 'site'
        cb = @async()
        pjson = jsonfile.readFileSync @destinationPath("./package.json")
        pjson.dependencies['angular-ui-router'] = "^0.3"
        jsonfile.spaces = 2
        jsonfile.writeFileSync @destinationPath("./package.json"), pjson
        cb()

module.exports = GarlicWebappGenerator
