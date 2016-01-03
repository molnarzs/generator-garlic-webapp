util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @config.set
        appName: @appname
      console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'

  writing:
    mainFiles: ->
      @config = @config.getAll()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"),
        appName: _.kebabCase @config.appName
        appNameCC: _.capitalize _.camelCase @config.appName
        appNameAsIs: @config.appName
      
      @fs.copy @templatePath('default_assets/**/*'), @destinationPath("./frontend/src/")


    "frontend/components.json" : ->
      dest = @destinationPath "./frontend/src/components.json"

      if not @fs.exists dest
        @fs.writeJSON dest,
          uiModuleNames: []
          factoryModuleNames: []
          serviceModuleNames: []


    "frontend/ui-modules.coffee" : ->
      dest = @destinationPath "./frontend/src/ui-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@config.appName}-ui", []
module.exports = Module.name
"""


    "frontend/service-modules.coffee" : ->
      dest = @destinationPath "./frontend/src/service-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@config.appName}-services", []
module.exports = Module.name
"""


    "frontend/factory-modules.coffee" : ->
      dest = @destinationPath "./frontend/src/factory-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@config.appName}-factories", []
module.exports = Module.name
"""

    "frontend/views/test-page/test-page-components.jade" : ->
      dest = @destinationPath "./frontend/src/views/test-page/test-page-components.jade"
      if not @fs.exists dest then @fs.write dest, ""

  install:
    dependencies: ->
      cb = @async()
      if not @options['skip-install'] then @installDependencies()
      cb()

  end:
    linkGtComplib: ->
      cb = @async()
      if not @options['skip-install']
        console.log "\nLinking gt-complib.\n"
        @spawnCommand 'npm', ['link', 'gt-complib']
      cb()

  # runGit: ->
  #   done = @async()

  #   if not @githubAuthtoken
  #     console.log "\nWarning: Github repo not created: github oauth token is unknown or invalid.\n"
  #     return

  #   console.log "\nCreating GitHub repo...\n"
  #   execute "curl https://api.github.com/orgs/garlictech/repos -u #{@githubAuthtoken}:x-oauth-basic -d \'{\"name\":\"#{@appname}\"}\'"
  #   execute "git init"
  #   execute "git remote add origin https://github.com/garlictech/#{@appname}.git"
  #   execute "git add ."
  #   execute "git commit -m 'Initial version.'"
  #   execute 'git push -u origin master'
  #   done()

module.exports = GarlicWebappGenerator
