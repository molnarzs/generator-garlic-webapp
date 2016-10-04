util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
mkdirp = require 'mkdirp'
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
    @composeWith 'garlic-webapp:angular-docker', {options: {"skip-install": true}}

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
      }, {
        type    : 'list'
        name    : 'projectType'
        default : 'module'
        choices : ['module', 'site']
        message : 'Project type:'
      }
    ], cb.bind @

  writing:
    createConfig: ->
      generatorLib.createConfig.bind(@)()
      console.log @conf
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

    "src/views/test-page/test-view-components.jade" : ->
      dest = @destinationPath "./src/views/test-view/test-view-components.jade"
      if not @fs.exists dest then @fs.write dest, ""


    dotfiles: ->
      @fs.copy @templatePath('default/.*'), @destinationPath("./")

  # install:
  #   dependencies: ->
  #     generatorLib.dependencies.bind(@)()

module.exports = GarlicWebappGenerator
