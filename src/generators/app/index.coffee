util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'

execute = (command) ->
  result = sh.exec command
  console.log result.stdout

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
        appName: @config.appName
        appNameCC: _.camelCase @config.appName
      
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
    linkGtComplib: ->
      if not @options['skip-install']
        console.log "\nLinking gt-complib.\n"
        @spawnCommand 'npm', ['link', 'gt-complib']

    dependencies: ->
      if not @options['skip-install'] then @installDependencies()

    selenium: ->
      if not @options['skip-install']
        console.log "\Updating selenium...\n"
        @spawnCommand "node_modules/protractor/bin/webdriver-manager", ["update", "--standalone"]

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
